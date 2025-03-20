//
//  LikeClient.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/18/25.
//

import Alamofire
import Dependencies

struct LikeClient {
    var getLikeList: @Sendable (_ token: String) async throws -> [RestaurantListModel]
    var postLike: @Sendable (_ token: String, _ id: Int) async throws -> Bool
    var postDislike: @Sendable (_ token: String, _ id: Int) async throws -> Bool
}

extension LikeClient: DependencyKey {
    static var liveValue: LikeClient = .init(
        getLikeList: { token in
            let url = "\(Environment.baseUrl)/api/profile/liked"
            
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(token)"
            ]
            
            let response = try await AF.request(
                url,
                method: .get,
                headers: headers
            )
            .serializingDecodable(ResponseModel<[RestaurantListModel]>.self)
            .value
            
            guard response.isSuccess else { throw RestaurantListError(rawValue: response.code) ?? .unknown }
            return response.data!
        },
        postLike: { token, id in
            let url = "\(Environment.baseUrl)/api/restaurant/like"
            
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(token)"
            ]
            
            let parameters = ["id": id]
            
            let response = try await AF.request(
                url,
                method: .post,
                parameters: parameters,
                encoder: .json,
                headers: headers
            )
            .serializingDecodable(ResponseModel<String>.self)
            .value
            
            guard response.isSuccess else { throw LikeError(rawValue: response.code) ?? .unknown }
            return response.isSuccess
        },
        postDislike: { token, id in
            let url = "\(Environment.baseUrl)/api/restaurant/dislike"
            
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(token)"
            ]
            
            let parameters = ["id": id]
            
            let response = try await AF.request(
                url,
                method: .post,
                parameters: parameters,
                encoder: .json,
                headers: headers
            )
            .serializingDecodable(ResponseModel<String>.self)
            .value
            
            guard response.isSuccess else { throw LikeError(rawValue: response.code) ?? .unknown }
            return response.isSuccess
        }
    )
}

extension DependencyValues {
    var likeClient: LikeClient {
        get { self[LikeClient.self] }
        set { self[LikeClient.self] = newValue }
    }
}
