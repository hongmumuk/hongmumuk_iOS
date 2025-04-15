//
//  RandomFeature.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/25/25.
//

import ComposableArchitecture

struct RandomFeature: Reducer {
    enum ActiveScreen: Equatable {
        case restaurantDetail(Int)
        case none
    }
    
    struct State: Equatable {
        var isLoading = true
        var restaurantName: String = ""
        var restaurantCategory: Category = .korean
        var restaurantCategoryName: String = ""
        var restaurantImageUrl: String = ""
        var restaurantId: Int = 0
        var restrauntList = [RestaurantListModel]()
        
        var title: String = "menu_selection_help".localized()
        var subTitle: String = "press_random_button".localized()
        var buttonTitle: String = "랜덤 뽑기"
        
        var startPick = false
        var isAnimating = true
        
        var activeScreen: ActiveScreen = .none
    }
    
    enum Action: Equatable {
        case onAppear
        case onDismiss
        case randomButtonTapped
        case detailButtonTapped
        case initailLoadingCompleted
        case restrauntListLoaded([RestaurantListModel])
        case restrauntListError(RestaurantListError)
        case endAnimation
    }
    
    @Dependency(\.restaurantClient) var restaurantClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return fetchRestaurantList { send in
                    await send(.initailLoadingCompleted)
                }
                
            case .onDismiss:
                state.activeScreen = .none
                return .none
                
            case .randomButtonTapped:
                if !state.startPick {
                    state.startPick = true
                    state.title = "menu_suggestion_today".localized()
                    state.subTitle = "메뉴가 마음에 들지 않으면 다시 뽑아 보세요"
                    state.buttonTitle = "다시 뽑기"
                } else {
                    let randomItem = getRandom(state: state)
                    state.restaurantName = randomItem.name
                    state.restaurantCategoryName = randomItem.category.displayName
                    state.restaurantCategory = randomItem.category
                    state.restaurantImageUrl = randomItem.imageUrl ?? ""
                    state.restaurantId = randomItem.id
                }
                
                return .none
                
            case .detailButtonTapped:
                state.activeScreen = .restaurantDetail(state.restaurantId)
                
                return .none
                
            case .endAnimation:
                state.isAnimating = false
                return .none
                
            case .initailLoadingCompleted:
                state.isLoading = false
                return .none

            case let .restrauntListLoaded(list):
                state.restrauntList = list
                let randomItem = getRandom(state: state)
                state.restaurantName = randomItem.name
                state.restaurantCategoryName = randomItem.category.displayName
                state.restaurantCategory = randomItem.category
                state.restaurantImageUrl = randomItem.imageUrl ?? ""
                state.restaurantId = randomItem.id
                
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
