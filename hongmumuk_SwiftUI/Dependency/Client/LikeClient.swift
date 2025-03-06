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
        }
    )
    
    static var testValue: LikeClient = .init(
        getLikeList: { _ in return RestaurantListModel.mock() }
    )
}

extension DependencyValues {
    var likeClient: LikeClient {
        get { self[LikeClient.self] }
        set { self[LikeClient.self] = newValue }
    }
}
