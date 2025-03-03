//
//  RestaurantClient.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/15/25.
//

import Alamofire
import Dependencies

struct RestaurantClient {
    var postRestaurantList: @Sendable (_ body: RestaurantListRequestModel) async throws -> [RestaurantListModel]
    var getRestaurantDetail: @Sendable (_ id: Int) async throws -> RestaurantDetail
}

extension RestaurantClient: DependencyKey {
    static var liveValue: RestaurantClient = .init(
        postRestaurantList: { body in
            let url = "\(Environment.baseUrl)/api/category"
            let headers: HTTPHeaders = [
                "accept": "*/*",
                "Content-Type": "application/json"
            ]
            
            let response = try await AF.request(
                url,
                method: .post,
                parameters: body,
                encoder: .json,
                headers: headers
            )
            .serializingDecodable(ResponseModel<[RestaurantListModel]>.self)
            .value
            
            guard response.isSuccess else { throw RestaurantListError(rawValue: response.code) ?? .unknown }
            return response.data!
        },
        
        getRestaurantDetail: { id in
            let url = "\(Environment.baseUrl)/api/restaurant/\(id)"
            // 토큰 추가해야 됨
            let headers: HTTPHeaders = ["Content-Type": "application/json"]
            
            let response = try await AF.request(
                url,
                method: .get,
                headers: headers
            )
            
            .serializingDecodable(ResponseModel<RestaurantDetail>.self)
            .value
            
            guard response.isSuccess else { throw RestaurantDetailError(rawValue: response.code) ?? .unknown }
            return response.data!
        }
    )
    
    static var testValue: RestaurantClient = .init(
        postRestaurantList: { _ in return RestaurantListModel.mock() },
        getRestaurantDetail: { _ in return RestaurantDetail.mock() }
    )
}

extension DependencyValues {
    var restaurantClient: RestaurantClient {
        get { self[RestaurantClient.self] }
        set { self[RestaurantClient.self] = newValue }
    }
}
