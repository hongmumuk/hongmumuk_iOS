//
//  NetworkInterceptor.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 3/24/25.
//

import Alamofire
import Foundation

final class NetworkInterceptor: RequestInterceptor {
    private let keychainClient = KeychainClient.liveValue
    private let authClient = AuthClient.liveValue
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) async {
        var request = urlRequest

        if let token = try? await keychainClient.getString(.accessToken), !token.isEmpty {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        completion(.success(request))
    }

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(.doNotRetry)
            return
        }

        Task {
            do {
                guard
                    let oldAccess = try? await keychainClient.getString(.accessToken),
                    let refresh = try? await keychainClient.getString(.refreshToken)
                else {
                    completion(.doNotRetry)
                    return
                }

                let newToken = try await authClient.token(oldAccess, refresh)
                try await keychainClient.setString(newToken.accessToken, .accessToken)
                try await keychainClient.setString(newToken.refreshToken, .refreshToken)

                completion(.retry)
            } catch {
                NotificationCenter.default.post(name: .shouldLogout, object: nil)
                completion(.doNotRetry)
            }
        }
    }
}
