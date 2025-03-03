//
//  DetailFeature.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/22/25.
//

import ComposableArchitecture
import SwiftUI

struct DetailFeature: Reducer {
    struct State: Equatable {
        var id: Int
        var isLoading = true
        var keywords = [String]()
        var pickerSelection = 0
        var restaurantDetail = RestaurantDetail.mock()
    }
    
    enum Action: Equatable {
        case onAppear
        case pickerSelectionChanged(Int)
        case restrauntDetailLoad(RestaurantDetail)
        case restaurantDetailError(RestaurantDetailError)
        case copyAddressButtonTapped
        case reviewTapped(String)
    }
    
    @Dependency(\.restaurantClient) var restaurantClient
    @Dependency(\.keywordClient) var keywordClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                let rid = state.id
                
                return .run { send in
                    do {
                        let restaurantDetail = try await restaurantClient.getRestaurantDetail(rid)
                        await send(.restrauntDetailLoad(restaurantDetail))
                    } catch {
                        if let error = error as? RestaurantDetailError {
                            await send(.restaurantDetailError(error))
                        }
                    }
                }
                
            case let .pickerSelectionChanged(index):
                state.pickerSelection = index
                return .none
                
            case let .restrauntDetailLoad(restaurantDetail):
                let blogString = restaurantDetail.blogs
                    .map { "\($0.title) \($0.subtitle)" }
                    .joined(separator: "\n")
                state.keywords = keywordClient.extractKeywords(blogString)
                state.restaurantDetail = restaurantDetail
                state.isLoading = false
                return .none
                
            case let .restaurantDetailError(error):
                state.isLoading = false
                // TODO: 에러 처리
                return .none
                
            case .copyAddressButtonTapped:
                let address = state.restaurantDetail.address
                UIPasteboard.general.string = address
                return .none
                
            case let .reviewTapped(link):
                guard let url = URL(string: link) else { return .none }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                return .none
            }
        }
    }
}
