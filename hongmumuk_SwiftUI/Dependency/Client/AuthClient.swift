//
//  AuthClient.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/10/25.
//

import Alamofire
import Dependencies

struct AuthClient {
    var login: @Sendable (_ body: LoginModel) async throws -> AuthTokenResponseModel
    var sendVerificationEmail: @Sendable (_ body: SendVerifyCodeModel) async throws -> Bool
    var verifyEmailCode: @Sendable (_ body: VerifyEmailModel) async throws -> Bool
    var resetPassword: @Sendable (_ body: ResetPasswordModel) async throws -> Bool
    var signup: @Sendable (_ body: LoginModel) async throws -> Bool
    var token: @Sendable (_ accessToken: String, _ refreshToken: String) async throws -> AuthTokenResponseModel
}

extension AuthClient: DependencyKey {
    static var liveValue: AuthClient = .init(
        login: { body in
            let url = "\(Constant.baseUrl)/api/auth/login"
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
            print(response.code)
            guard response.isSuccess, let tokenData = response.data else {
                switch response.code {
                case "BAD400_1": throw LoginError.userNotFound
                case "BAD400_2": throw LoginError.invalidCredentials
                default: throw LoginError.unknown
                }
            }
            
            return tokenData
        },
        sendVerificationEmail: { body in
            let url = "\(Constant.baseUrl)/api/auth/send"
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
            let url = "\(Constant.baseUrl)/api/auth/verify"
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
            let url = "\(Constant.baseUrl)/api/auth/password"
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
            let url = "\(Constant.baseUrl)/api/auth/join"
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
        token: { accessToken, refreshToken in
            let url = "\(Constant.baseUrl)/api/auth/token"
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(accessToken)",
                "refreshToken": refreshToken
            ]
            
            // API 요청을 보내는 부분
            let response = try await AF.request(
                url,
                method: .get,
                headers: headers
            )
            .serializingDecodable(ResponseModel<AuthTokenResponseModel>.self)
            .value
            
            guard response.isSuccess, let tokenData = response.data else {
                // 실패한 경우
                throw LoginError(rawValue: response.code) ?? .unknown
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
