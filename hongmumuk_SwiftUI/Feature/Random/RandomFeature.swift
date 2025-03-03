//
//  RandomFeature.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/25/25.
//

import ComposableArchitecture

struct RandomFeature: Reducer {
    struct State: Equatable {
        var isLoading = true
        var restaurantName: String = ""
        var restaurantCategory: String = ""
        var restrauntList = [RestaurantListModel]()
    }
    
    enum Action: Equatable {
        case onAppear
        case retryButtonTapped
        case initailLoadingCompleted
        case restrauntListLoaded([RestaurantListModel])
        case restrauntListError(RestaurantListError)
    }
    
    @Dependency(\.restaurantClient) var restaurantClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return fetchRestaurantList { send in
                    await send(.initailLoadingCompleted)
                }
                
            case .retryButtonTapped:
                let randomItem = getRandom(state: state)
                state.restaurantName = randomItem.name
                state.restaurantCategory = randomItem.category
                
                return .none
                
            case .initailLoadingCompleted:
                state.isLoading = false
                return .none

            case let .restrauntListLoaded(list):
                state.restrauntList = list
                let randomItem = getRandom(state: state)
                state.restaurantName = randomItem.name
                state.restaurantCategory = randomItem.category
                
                return .none
                
            case let .restrauntListError(error):
                // TODO: Error 처리
                return .none
            }
        }
    }
    
    func fetchRestaurantList(
        extra: @escaping (Send<RandomFeature.Action>) async -> Void = { _ in }
    ) -> Effect<Action> {
        return .run { send in
            do {
                let body = RestaurantListRequestModel(category: .all, page: -1, sort: .likes)
                let list = try await restaurantClient.postRestaurantList(body)
                await send(.restrauntListLoaded(list))
                await extra(send)
            } catch {
                if let error = error as? RestaurantListError {
                    await send(.restrauntListError(error))
                }
            }
        }
    }
    
    func getRandom(state: State) -> RestaurantListModel {
        return state.restrauntList
            .filter { $0.name != state.restaurantName }
            .shuffled()
            .first!
    }
}
