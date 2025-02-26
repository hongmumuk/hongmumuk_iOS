//
//  AuthClient.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/10/25.
//

import Alamofire
import Dependencies

struct AuthClient {
    var login: @Sendable (_ body: LoginModel) async throws -> Bool
}

extension AuthClient: DependencyKey {
    static var liveValue: AuthClient = .init(
        login: { body in
            let url = "\(Environment.baseUrl)/api/auth/login"
            let headers: HTTPHeaders = ["Content-Type": "application/json"]
            
            let response = try await AF.request(
                url,
                method: .post,
                parameters: body,
                encoder: .json,
                headers: headers
            )
            .serializingDecodable(ResponseModel<LoginModel>.self)
            .value
            
            guard response.isSuccess else { throw LoginError(rawValue: response.code) ?? .unKnown }
            return response.isSuccess
        }
    )
}

extension DependencyValues {
    var authClient: AuthClient {
        get { self[AuthClient.self] }
        set { self[AuthClient.self] = newValue }
    }
}
