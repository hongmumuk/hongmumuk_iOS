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
        var token = ""
        var isUser = false
        var keywords = [String]()
        var pickerSelection = 0
        var restaurantDetail = RestaurantDetail.mock()
    }
    
    enum Action: Equatable {
        case onAppear
        case pickerSelectionChanged(Int)
        case restrauntDetailLoad(RestaurantDetail)
        case restaurantDetailError(RestaurantDetailError)
        case likeLoaded(TaskResult<Bool>)
        case copyAddressButtonTapped
        case likeButtonTapped
        case reviewTapped(String)
        case checkIsUser(String?)
    }
    
    enum DebounceID {
        case likeButton
    }
    
    @Dependency(\.restaurantClient) var restaurantClient
    @Dependency(\.likeClient) var likeClient
    @Dependency(\.keywordClient) var keywordClient
    @Dependency(\.keychainClient) var keychainClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    let accessToken = await keychainClient.getString(.accessToken)
                    await send(.checkIsUser(accessToken))
                }
                
            case let .checkIsUser(token):
                state.isUser = token != nil
                
                if let token {
                    state.token = token
                }
                
                let rid = state.id
                
                return .run { send in
                    do {
                        let restaurantDetail: RestaurantDetail = if let token {
                            try await restaurantClient.getAuthedRestaurantDetail(rid, token)
                        } else {
                            try await restaurantClient.getRestaurantDetail(rid)
                        }
                        
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
                
            case .likeButtonTapped:
                state.restaurantDetail.hasLiked.toggle()
                state.restaurantDetail.likes += state.restaurantDetail.hasLiked ? 1 : -1
                
                let likeState = state.restaurantDetail.hasLiked
                let id = state.id
                let token = state.token
                
                return .run { send in
                    let result = await TaskResult {
                        if likeState {
                            try await likeClient.postLike(token, id)
                        } else {
                            try await likeClient.postDislike(token, id)
                        }
                    }
                    
                    await send(.likeLoaded(result))
                }
                .debounce(id: DebounceID.likeButton, for: 0.3, scheduler: DispatchQueue.main)
                
            case let .reviewTapped(link):
                guard let url = URL(string: link) else { return .none }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                return .none
                
            case .likeLoaded(.success):
                return .none

            case let .likeLoaded(.failure(error)):
                return .none
            }
        }
    }
}
