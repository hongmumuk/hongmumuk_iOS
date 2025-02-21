//
//  LikeClient.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/18/25.
//

import Alamofire
import Dependencies

struct LikeClient {
    var getLikeList: @Sendable () async throws -> [RestaurantListModel]
}

extension LikeClient: DependencyKey {
    static var liveValue: LikeClient = .init(
        getLikeList: {
            let url = "\(Environment.baseUrl)/api/liked"
            let headers: HTTPHeaders = ["Content-Type": "application/json"]
            
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
        getLikeList: { return RestaurantListModel.mock() }
    )
}

extension DependencyValues {
    var likeClient: LikeClient {
        get { self[LikeClient.self] }
        set { self[LikeClient.self] = newValue }
    }
}
