//
//  ProfileClient.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 3/7/25.
//

import Alamofire
import Dependencies

struct ProfileClient {
    var getProfile: @Sendable (_ token: String) async throws -> ProfileModel
}

extension ProfileClient: DependencyKey {
    static var liveValue: ProfileClient = .init(
        getProfile: { token in
            let url = "\(Environment.baseUrl)/api/profile"
            
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(token)"
            ]
            
            let response = try await AF.request(
                url,
                method: .get,
                headers: headers
            )
            .serializingDecodable(ResponseModel<ProfileModel>.self)
            .value
            
            guard response.isSuccess else { throw ProfileError(rawValue: response.code) ?? .unknown }
            return response.data!
        }
    )
}

extension DependencyValues {
    var profileClient: ProfileClient {
        get { self[ProfileClient.self] }
        set { self[ProfileClient.self] = newValue }
    }
}
