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
    var getAuthedRestaurantDetail: @Sendable (_ id: Int, _ token: String) async throws -> RestaurantDetail
    var getReviews: @Sendable (_ rid: Int, _ page: Int, _ sort: ReviewSortOption, _ isUser: Bool) async throws -> ReviewResponse
    var checkReviewAvailable: @Sendable (_ rid: Int, _ token: String) async throws -> Void
}

extension RestaurantClient: DependencyKey {
    static var liveValue: RestaurantClient = .init(
        postRestaurantList: { body in
            let url = "\(Constant.baseUrl)/api/category"
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
            let url = "\(Constant.baseUrl)/api/restaurant"
            
            let parameters: [String: Any] = [
                "restaurantId": id,
                "isUser": false
            ]
            
            let headers: HTTPHeaders = [
                "Content-Type": "application/json"
            ]
            
            let request = APIClient.plain.request(
                url,
                method: .get,
                parameters: parameters,
                encoding: URLEncoding.default,
                headers: headers
            )
            
            let response = try await request
                .serializingDecodable(ResponseModel<RestaurantDetail>.self)
                .value
            
            guard response.isSuccess else { throw RestaurantDetailError(rawValue: response.code) ?? .unknown }
            
            return response.data!
        },
        
        getAuthedRestaurantDetail: { id, token in
            let url = "\(Constant.baseUrl)/api/restaurant"
            
            let parameters: [String: Any] = [
                "restaurantId": id,
                "isUser": true
            ]
            
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(token)"
            ]
            
            let request = APIClient.authorized.request(
                url,
                method: .get,
                parameters: parameters,
                encoding: URLEncoding.default,
                headers: headers
            )
            
            let response = try await request
                .serializingDecodable(ResponseModel<RestaurantDetail>.self)
                .value
            
            guard response.isSuccess else { throw RestaurantDetailError(rawValue: response.code) ?? .unknown }
            
            return response.data!
        },
        
        getReviews: { rid, page, sort, isUser in
            let url = "\(Constant.baseUrl)/api/review"
            
            let parameters: [String: Any] = [
                "restaurantId": rid,
                "page": page,
                "sort": sort.rawValue,
                "isUser": isUser
            ]
            
            let headers: HTTPHeaders = [
                "Content-Type": "application/json"
            ]
            
            let request = APIClient.plain.request(
                url,
                method: .get,
                parameters: parameters,
                encoding: URLEncoding.default,
                headers: headers
            )
            
            let response = try await request
                .serializingDecodable(ResponseModel<ReviewResponse>.self)
                .value
            
            guard response.isSuccess else { throw ReviewError(rawValue: response.code) ?? .unknown }
            
            return response.data!
        },
        
        checkReviewAvailable: { rid, token in
            let url = "\(Constant.baseUrl)/api/review/available/\(rid)"
            
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(token)"
            ]
            
            let request = APIClient.plain.request(
                url,
                method: .get,
                headers: headers
            )
            
            let response = try await request
                .serializingDecodable(ResponseModel<String?>.self)
                .value
            
            guard response.isSuccess else { 
                if let reviewError = ReviewError(rawValue: response.code) {
                    throw reviewError
                } else {
                    throw ReviewError.unknown
                }
            }
        }
    )
    
    static var testValue: RestaurantClient = .init(
        postRestaurantList: { _ in return RestaurantListModel.mock() },
        getRestaurantDetail: { _ in return RestaurantDetail.mock() },
        getAuthedRestaurantDetail: { _, _ in return RestaurantDetail.mock() },
        getReviews: { _, _, _, _ in
            return ReviewResponse(
                reviewCount: 3,
                reviews: [
                    Review(
                        id: 1,
                        user: "홍무묵1",
                        date: "2025-07-11",
                        star: 5,
                        content: "완전 맛있어요~",
                        isOwner: false,
                        photoURLs: ["https://example.com/photo1.jpg"],
                        badge: .master
                    ),
                    Review(
                        id: 2,
                        user: "홍무묵2",
                        date: "2025-07-11",
                        star: 4,
                        content: "맛있어요~",
                        isOwner: false,
                        photoURLs: ["https://example.com/photo2.jpg"],
                        badge: .foodie
                    ),
                    Review(
                        id: 3,
                        user: "홍무묵3",
                        date: "2025-07-11",
                        star: 3,
                        content: "잡숴봐~",
                        isOwner: false,
                        photoURLs: [],
                        badge: .explorer
                    )
                ]
            )
        },
        checkReviewAvailable: { _, _ in
            return
        }
    )
}

extension DependencyValues {
    var restaurantClient: RestaurantClient {
        get { self[RestaurantClient.self] }
        set { self[RestaurantClient.self] = newValue }
    }
}
