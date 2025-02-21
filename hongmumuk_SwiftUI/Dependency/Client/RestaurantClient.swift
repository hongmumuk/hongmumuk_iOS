//
//  RestaurantClient.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/15/25.
//

import Alamofire
import Dependencies

struct RestaurantClient {
    var getRestaurantList: @Sendable (_ body: RestaurantListRequestModel) async throws -> [RestaurantListModel]
}

extension RestaurantClient: DependencyKey {
    static var liveValue: RestaurantClient = .init(
        getRestaurantList: { body in
            let url = "\(Environment.baseUrl)/api/category"
            let headers: HTTPHeaders = ["Content-Type": "application/json"]
            
            let response = try await AF.request(
                url,
                method: .get,
                parameters: body,
                encoder: .json,
                headers: headers
            )
            .serializingDecodable(ResponseModel<[RestaurantListModel]>.self)
            .value
            
            guard response.isSuccess else { throw RestaurantListError(rawValue: response.code) ?? .unknown }
            return response.data!
        }
    )
}

extension DependencyValues {
    var restaurantClient: RestaurantClient {
        get { self[RestaurantClient.self] }
        set { self[RestaurantClient.self] = newValue }
    }
}
