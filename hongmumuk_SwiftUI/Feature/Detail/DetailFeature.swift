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
        var showToast = false
        // var showToolTip = false
        
        var isWriteReviewPresented: Bool = false
        var showSkeletonLoading: Bool = true
        var reviewPage: Int = 0
        var isLastPage: Bool = false
        
        var isReviewLoading: Bool = false
        
        var reviewCount: Int = 0
        
        var showSortSheet: Bool = false
        var sort: ReviewSortOption = .newest
        var originalReviews = [Review]()
        var sortedReviews = [Review]()

        var isPhotoFilterOn: Bool = false
        var canWriteReview: Bool = false
        
        var showReviewActionSheet: Bool = false
    }
    
    enum Action: Equatable {
        case onAppear
        case onDismiss
        case onNextPage
        case pickerSelectionChanged(Int)
        case restrauntDetailLoad(RestaurantDetail)
        case restaurantDetailError(RestaurantDetailError)
        case likeLoaded(TaskResult<Bool>)
        case copyAddressButtonTapped
        case likeButtonTapped
        case reviewTapped(String)
        case checkIsUser(String?)
        case kakaoMapButtonTapped
        case naverMapButtonTapped
        case showCopyToast(Bool)
        case photoFilterToggled(Bool)
        case sortButtonTapped
        case sortChanged(ReviewSortOption)
        case initailLoadingCompleted
        case reviewLoaded([Review])
        case reviewError(ReviewError)
        case reviewEditButtonTapped(Int)
        case reviewDeleteButtonTapped(Int)
        
        // review 작성하는 것과 관련된 액션
        case writeReviewButtonTapped
        case reviewWriteCompleted
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
                    let token = await keychainClient.getString(.accessToken)
                    await send(.checkIsUser(token))
                }

            case .onDismiss:
                state.showSortSheet = false
                return .none
                
            case .onNextPage:
                if !state.isLastPage {
                    state.reviewPage += 1
                    return /* fetchReview(for: state) */ .none
                } else {
                    return .none
                }
                
            case let .checkIsUser(token):
                state.token = token ?? ""
                state.isUser = token != nil
                state.canWriteReview = token != nil

                let rid = state.id

                #if DEBUG
                    return .run { send in
                        let mock = RestaurantDetail.mock()
                        await send(.restrauntDetailLoad(mock))
                    }
                #else
                    return .run { send in
                        do {
                            let restaurantDetail: RestaurantDetail = if let token {
                                try await restaurantClient.getAuthedRestaurantDetail(rid, token)
                            } else {
                                RestaurantDetail.mock()
                            }
                            await send(.restrauntDetailLoad(restaurantDetail))
                        } catch {
                            if let error = error as? RestaurantDetailError {
                                await send(.restaurantDetailError(error))
                            }
                        }
                    }
                #endif
                
            case let .pickerSelectionChanged(index):
                state.pickerSelection = index
                return .none
                
            case let .restrauntDetailLoad(restaurantDetail):
                let blogString = restaurantDetail.blogs
                    .map { "\($0.title) \($0.subtitle)" }
                    .joined(separator: "\n")
                state.keywords = keywordClient.extractKeywords(blogString)
                state.restaurantDetail = restaurantDetail
                state.originalReviews = restaurantDetail.reviews
                applyFilterAndSort(state: &state)
                state.isLoading = false
                return .none
                
            case let .restaurantDetailError(error):
                state.isLoading = false
                return .none
                
            case .copyAddressButtonTapped:
                let address = state.restaurantDetail.address
                UIPasteboard.general.string = address
                return .run { send in
                    await send(.showCopyToast(true), animation: .default)
                }
                
            case let .showCopyToast(isShow):
                state.showToast = isShow
                
                if isShow {
                    return .run { send in
                        try await Task.sleep(for: .seconds(2.0))
                        await send(.showCopyToast(false), animation: .default)
                    }
                } else {
                    return .none
                }
                
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
                UIApplication.shared.open(url)
                return .none
                
            case .likeLoaded(.success):
                return .none
                
            case let .likeLoaded(.failure(error)):
                return .none
                
            case .kakaoMapButtonTapped:
                let urlString = state.restaurantDetail.kakaoLink
                if let url = URL(string: urlString) {
                    UIApplication.shared.open(url)
                }
                
                return .none
                
            case .naverMapButtonTapped:
                let urlString = state.restaurantDetail.naverLink
                if let url = URL(string: urlString) {
                    UIApplication.shared.open(url)
                }
                
                return .none
                
            case .sortButtonTapped:
                state.showSortSheet = true
                return .none
            
            case let .sortChanged(reviewSort):
                state.showSortSheet = false
                state.sort = reviewSort
                applyFilterAndSort(state: &state)
                return .none

            case let .photoFilterToggled(isOn):
                state.isPhotoFilterOn = isOn
                applyFilterAndSort(state: &state)
                return .none
                
            case .initailLoadingCompleted:
                state.showSkeletonLoading = false
                return .none
                
            case let .reviewLoaded(review):
                state.originalReviews += review
                state.reviewCount = state.originalReviews.count
                state.sortedReviews = sortReviews(state.sort, state.originalReviews)
                state.isLastPage = review.count <= 10
                return .none
                
            case let .reviewError(error):
                return .none
                
            case .writeReviewButtonTapped:
                state.isWriteReviewPresented = true
                return .none
                
            case .reviewWriteCompleted:
                state.isWriteReviewPresented = false
                state.reviewPage = 0
                return /* fetchReviews(for: state) */ .none
            
            case let .reviewEditButtonTapped(id):
                // TODO: 수정 로직 추가
                return .none

            case let .reviewDeleteButtonTapped(id):
                // TODO: 삭제 로직 추가
                return .none
            }
        }
    }
    
    private func sortReviews(_ sort: ReviewSortOption, _ list: [Review]) -> [Review] {
        switch sort {
        case .newest:
            return list.sorted { $0.date > $1.date }

        case .highestRating:
            return list.sorted { $0.star > $1.star }

        case .lowestRating:
            return list.sorted { $0.star < $1.star }
        }
    }
    
    private func applyFilterAndSort(state: inout State) {
        let filtered = state.isPhotoFilterOn
            ? state.originalReviews.filter { !$0.photoURLs.isEmpty }
            : state.originalReviews
        
        state.sortedReviews = sortReviews(state.sort, filtered)
        state.reviewCount = filtered.count
    }
    
//    func fetchReview(
//        for state: State,
//        extra: @escaping (Send<DetailFeature.Action>) async -> Void = { _ in }
//    ) -> Effect<Action> {
//        let body = RestaurantListRequestModel(category: state.cateogry, page: state.page, sort: state.sort)
//        return .run { send in
//            do {
//                let list = try await restaurantClient.postRestaurantList(body)
//                await send(.restaurantListLoaded(list))
//                await extra(send)
//            } catch {
//                if let error = error as? RestaurantListError {
//                    await send(.restaurantListError(error))
//                }
//            }
//        }
//    }
}
