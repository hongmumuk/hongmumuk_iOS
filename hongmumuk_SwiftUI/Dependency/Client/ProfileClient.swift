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
    var patchNickName: @Sendable (_ token: String, _ nickname: String) async throws -> Bool
    var deleteAccount: @Sendable (_ token: String) async throws -> Bool
    var postPassword: @Sendable (_ token: String, _ password: String) async throws -> Bool
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
        },
        patchNickName: { token, nickname in
            let url = "\(Environment.baseUrl)/api/profile/nickname/\(nickname)"
            
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(token)"
            ]

            let response = try await AF.request(
                url,
                method: .patch,
                headers: headers
            )
            .serializingDecodable(ResponseModel<String>.self)
            .value
            
            guard response.isSuccess else { throw NickNameError(rawValue: response.code) ?? .unknown }
            return response.isSuccess
        },
        
        deleteAccount: { token in
            let url = "\(Environment.baseUrl)/api/profile/quit"
            
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(token)"
            ]

            let response = try await AF.request(
                url,
                method: .delete,
                headers: headers
            )
            .serializingDecodable(ResponseModel<String>.self)
            .value
            
            guard response.isSuccess else { throw DeleteAccountError(rawValue: response.code) ?? .unknown }
            return response.isSuccess
        },
        
        postPassword: { token, password in
            let url = "\(Environment.baseUrl)/api/profile/check"
            
            let headers: HTTPHeaders = [
                //                "accept": "*/*",
                "Content-Type": "application/json",
                "Authorization": "Bearer \(token)"
            ]
            
            let parameters = ["password": password]
            
            let response = try await AF.request(
                url,
                method: .post,
                parameters: parameters,
                encoder: .json,
                headers: headers
            )
            .serializingDecodable(ResponseModel<String>.self)
            .value
            
            guard response.isSuccess else { throw PostPasswordError(rawValue: response.code) ?? .unknown }
            return response.isSuccess
        }
    )
}

extension DependencyValues {
    var profileClient: ProfileClient {
        get { self[ProfileClient.self] }
        set { self[ProfileClient.self] = newValue }
    }
}
