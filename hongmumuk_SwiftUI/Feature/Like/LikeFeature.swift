//
//  LikeFeature.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/18/25.
//

import ComposableArchitecture
import SwiftUI

struct LikeFeature: Reducer {
    enum ActiveScreen: Equatable {
        case none
        case restaurantDetail(Int)
    }
    
    struct State: Equatable {
        var activeScreen: ActiveScreen = .none
        var showSortSheet = false
        var sort: Sort = .likes
        var showSkeletonLoading = true
        var restrauntCount: Int = 0
        var sortedRestaurantList = [RestaurantListModel]()
        var originRestaurantList = [RestaurantListModel]()
        var isAuthed = false
    }
    
    enum Action: Equatable {
        case onAppear
        case onDismiss
        case checkIsUser(String?)
        case emailLoginButtonTapped
        case restrauntTapped(id: Int)
        case sortButtonTapped
        case sortChanged(Sort)
        case initialLoadingCompleted
        case restrauntListLoaded([RestaurantListModel])
        case restrauntListError(RestaurantListError)
    }
    
    @Dependency(\.likeClient) var likeClient
    @Dependency(\.keychainClient) var keychainClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    let accessToken = await keychainClient.getString(.accessToken)
                    await send(.checkIsUser(accessToken))
                }
                
            case .onDismiss:
                state.showSortSheet = false
                state.activeScreen = .none
                return .none
                
            case let .checkIsUser(token):
                if let token {
                    state.isAuthed = true
                    return fetchRestaurantList(for: state, token: token) { send in
                        await send(.initialLoadingCompleted)
                    }
                } else {
                    state.showSkeletonLoading = false
                    return .none
                }

            case .emailLoginButtonTapped:
                // TODO: 로그인 화면으로 이동
                return .none
                
            case let .restrauntTapped(id):
                state.activeScreen = .restaurantDetail(id)
                return .none
                
            case .sortButtonTapped:
                state.showSortSheet = true
                return .none
                
            case let .sortChanged(sort):
                state.showSortSheet = false
                state.sort = sort
                state.sortedRestaurantList = sortList(sort, state.originRestaurantList)
                return .none
                
            case .initialLoadingCompleted:
                state.showSkeletonLoading = false
                return .none
                
            case let .restrauntListLoaded(list):
                state.originRestaurantList += list
                state.restrauntCount = state.originRestaurantList.count
                state.sortedRestaurantList = sortList(state.sort, state.originRestaurantList)
                return .none
                
            case let .restrauntListError(error):
                state.showSkeletonLoading = false
                return .none
            }
        }
    }

    private func sortList(_ sort: Sort, _ list: [RestaurantListModel]) -> [RestaurantListModel] {
        switch sort {
        case .likes:
            return list.sorted { $0.likes > $1.likes }
        case .front:
            return list.sorted { $0.frontDistance < $1.frontDistance }
        case .back:
            return list.sorted { $0.backDistance < $1.backDistance }
        case .name:
            return list.sorted { $0.name < $1.name }
        }
    }
    
    func fetchRestaurantList(
        for state: State,
        token: String,
        extra: @escaping (Send<LikeFeature.Action>) async -> Void = { _ in }
    ) -> Effect<Action> {
        return .run { send in
            do {
                let list = try await likeClient.getLikeList(token)
                await send(.restrauntListLoaded(list))
                await extra(send)
            } catch {
                if let error = error as? RestaurantListError {
                    await send(.restrauntListError(error))
                }
            }
        }
    }
}
