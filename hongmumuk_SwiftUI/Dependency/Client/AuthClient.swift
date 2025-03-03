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
    var sendVerificationEmail: @Sendable (_ body: SendVerifyCodeModel) async throws -> Bool
    var verifyEmailCode: @Sendable (_ body: VerifyEmailModel) async throws -> Bool
    var resetPassword: @Sendable (_ body: LoginModel) async throws -> Bool
    var signup: @Sendable (_ body: LoginModel) async throws -> AuthTokenResponseModel
}

// 로그인 수정 필요!
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
        
            guard response.isSuccess else { throw LoginError(rawValue: response.code) ?? .unknown }
            return response.isSuccess
        },
        sendVerificationEmail: { body in
            let url = "\(Environment.baseUrl)/api/auth/send"
            let headers: HTTPHeaders = ["Content-Type": "application/json"]
        
            let response = try await AF.request(
                url,
                method: .post,
                parameters: body,
                encoder: .json,
                headers: headers
            )
            .serializingDecodable(ResponseModel<VoidData>.self)
            .value
        
            guard response.isSuccess else {
                if response.code == "CONFLICT409_1" {
                    throw LoginError.alreadyExists
                } else if response.code == "BAD400_1" {
                    throw LoginError.userNotFound
                }
                throw LoginError(rawValue: response.code) ?? .unknown
            }
            return response.isSuccess
        },
        verifyEmailCode: { body in
            let url = "\(Environment.baseUrl)/api/auth/verify"
            let headers: HTTPHeaders = ["Content-Type": "application/json"]
        
            let response = try await AF.request(
                url,
                method: .post,
                parameters: body,
                encoder: .json,
                headers: headers
            )
            .serializingDecodable(ResponseModel<VoidData>.self)
            .value
        
            guard response.isSuccess else {
                switch response.code {
                case "BAD400": throw LoginError.noVerificationRecord
                case "BAD400_3": throw LoginError.expiredCode
                case "BAD400_4": throw LoginError.invalidCode
                default: throw LoginError.unknown
                }
            }
        
            return response.isSuccess
        },
        resetPassword: { body in
            let url = "\(Environment.baseUrl)/api/auth/password"
            let headers: HTTPHeaders = ["Content-Type": "application/json"]
        
            let response = try await AF.request(
                url,
                method: .patch,
                parameters: body,
                encoder: .json,
                headers: headers
            )
            .serializingDecodable(ResponseModel<VoidData>.self)
            .value
        
            guard response.isSuccess else {
                if response.code == "BAD400_1" {
                    throw LoginError.userNotFound
                }
                throw LoginError.unknown
            }
            return response.isSuccess
        },
        signup: { body in
            let url = "\(Environment.baseUrl)/api/auth/join"
            let headers: HTTPHeaders = ["Content-Type": "application/json"]
        
            let response = try await AF.request(
                url,
                method: .post,
                parameters: body,
                encoder: .json,
                headers: headers
            )
            .serializingDecodable(ResponseModel<AuthTokenResponseModel>.self)
            .value
        
            guard response.isSuccess, let tokenData = response.data else {
                switch response.code {
                case "BAD400": throw LoginError.noVerificationRecord
                case "BAD400_3": throw LoginError.expiredCode
                case "BAD400_4": throw LoginError.invalidCode
                default: throw LoginError.unknown
                }
            }
        
            return tokenData
        }
    )
}

extension DependencyValues {
    var authClient: AuthClient {
        get { self[AuthClient.self] }
        set { self[AuthClient.self] = newValue }
    }
}
