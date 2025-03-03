//
//  CategoryFeature.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/17/25.
//

import ComposableArchitecture
import SwiftUI

struct CategoryFeature: Reducer {
    enum ActiveScreen: Equatable {
        case none
        case restaurantDetail(String)
        case search
        case random
    }
    
    struct State: Equatable {
        var activeScreen: ActiveScreen = .none
        var showSortSheet = false
        var cateogry: Category
        var page: Int = 0
        var sort: Sort = .likes
        var isLastPage = false
        var showSkeletonLoading = true
        var restaurantCount: Int = 0
        var sortedRestaurantList = [RestaurantListModel]()
        var originRestaurantList = [RestaurantListModel]()
    }
    
    enum Action: Equatable {
        case onAppear
        case onDismiss
        case onNextPage
        case randomButtonTapped
        case inquryButtonTapped
        case searchButtonTapped
        case restaurantTapped(id: String)
        case sortButtonTapped
        case sortChanged(Sort)
        case initailLoadingCompleted
        case restaurantListLoaded([RestaurantListModel])
        case restaurantListError(RestaurantListError)
    }
    
    @Dependency(\.restaurantClient) var restaurantClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return fetchRestaurantList(for: state) { send in
                    await send(.initailLoadingCompleted)
                }
                
            case .onDismiss:
                state.showSortSheet = false
                state.activeScreen = .none
                return .none
                
            case .onNextPage:
                if !state.isLastPage {
                    state.page += 1
                    return fetchRestaurantList(for: state)
                } else {
                    return .none
                }
                
            case .randomButtonTapped:
                state.activeScreen = .random
                return .none
                
            case .inquryButtonTapped:
                // TODO: 문의하기 이동
                /// 링크 나오면 처리
                return .none
                
            case .searchButtonTapped:
                state.activeScreen = .search
                return .none
                
            case let .restaurantTapped(id):
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
                
            case .initailLoadingCompleted:
                state.showSkeletonLoading = false
                return .none
                
            case let .restaurantListLoaded(list):
                state.originRestaurantList += list
                state.restaurantCount = state.originRestaurantList.count
                state.sortedRestaurantList = sortList(state.sort, state.originRestaurantList)
                state.isLastPage = list.count <= 10
                return .none
                
            case let .restaurantListError(error):
                // TODO: 에러 처리
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
        extra: @escaping (Send<CategoryFeature.Action>) async -> Void = { _ in }
    ) -> Effect<Action> {
        let body = RestaurantListRequestModel(category: state.cateogry, page: state.page, sort: state.sort)
        return .run { send in
            do {
                let list = try await restaurantClient.getRestaurantList(body)
                await send(.restaurantListLoaded(list))
                await extra(send)
            } catch {
                print("error", error)
                if let error = error as? RestaurantListError {
                    await send(.restaurantListError(error))
                }
            }
        }
    }
}
