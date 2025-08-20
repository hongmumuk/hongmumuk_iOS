//
//  DetailFeature.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/22/25.
//

import ComposableArchitecture
import SwiftUI

struct ToastInfo: Equatable {
    let imageName: String
    let message: String
}

struct DetailFeature: Reducer {
    struct State: Equatable {
        var id: Int
        var isLoading = true
        var token = ""
        var isUser = false
        var keywords = [String]()
        var pickerSelection = 0
        var restaurantDetail = RestaurantDetail()
        var currentToast: ToastInfo? = nil
        var activeToolTipReviewID: Int? = nil
        
        var isWriteReviewPresented: Bool = false
        var showSkeletonLoading: Bool = true
        var reviewPage: Int = 0
        var isLastPage: Bool = false
        
        var isReviewLoading: Bool = false
        
        var reviewCount: Int = 0
        
        var showSortSheet: Bool = false
        var sort: ReviewSortOption = .recent
        var originalReviews = [Review]()
        var sortedReviews = [Review]()

        var isPhotoFilterOn: Bool = false
        var canWriteReview: Bool = false
        
        var showReviewActionSheet: Bool = false
        var showLoginAlert: Bool = false
        
        var isSuccessWriteReview: Bool = false
        var showDeleteAlert: Bool = false
        var reviewToDelete: Int? = nil
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
        case showToast(ToastInfo)
        case hideToast
        case photoFilterToggled(Bool)
        case sortButtonTapped
        case sortChanged(ReviewSortOption)
        case initailLoadingCompleted
        case reviewLoaded([Review])
        case reviewError(ReviewError)
        case reviewDeleteButtonTapped(Int)
        case reviewDeleteConfirmed(Int)
        case reviewDeleted(Int)
        case reviewDeleteError(String)
        case deleteAlertDismissed
        
        // 로딩 상태 관리 액션
        case loadingStarted
        case loadingFinished
        
        case showToolTip(id: Int)
        case hideToolTip
        
        // review 작성하는 것과 관련된 액션
        case writeReviewButtonTapped
        case reviewWriteCompleted(Bool)
        case showLoginAlert(Bool)
        case reviewAvailabilityChecked
        case reviewAvailabilityError(ReviewError)
        case isSuccessWriteReview(Bool)
        
        case emptyAction
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
                if !state.isLastPage, !state.isReviewLoading {
                    state.isReviewLoading = true
                    state.reviewPage += 1
                    
                    return .run { [id = state.id, page = state.reviewPage, sort = state.sort, isUser = state.isUser, token = state.token] send in
                        do {
                            let tokenToSend = token.isEmpty ? nil : token
                            let reviewResponse = try await restaurantClient.getReviews(id, page, sort, isUser, tokenToSend)
                            await send(.reviewLoaded(reviewResponse.reviews))
                        } catch let error as ReviewError {
                            await send(.reviewError(error))
                        } catch {
                            await send(.reviewError(.unknown))
                        }
                    }
                } else {
                    return .none
                }
                
            case let .checkIsUser(token):
                state.token = token ?? ""
                state.isUser = token != nil
                state.canWriteReview = token != nil

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
                
                return .concatenate(
                    .send(.loadingStarted),
                    .run { [id = state.id, sort = state.sort, isUser = state.isUser, token = state.token] send in
                        do {
                            let tokenToSend = token.isEmpty ? nil : token
                            let reviewResponse = try await restaurantClient.getReviews(id, 0, sort, isUser, tokenToSend)
                            await send(.reviewLoaded(reviewResponse.reviews))
                        } catch let error as ReviewError {
                            await send(.reviewError(error))
                        } catch {
                            await send(.reviewError(.unknown))
                        }
                    }
                )
                
            case let .restaurantDetailError(error):
                state.isLoading = false
                return .none
                
            case .copyAddressButtonTapped:
                let address = state.restaurantDetail.address
                UIPasteboard.general.string = address
                let toastInfo = ToastInfo(
                    imageName: "checkWhiteIcon",
                    message: "copied_store_address".localized()
                )
                return .run { send in
                    await send(.showToast(toastInfo), animation: .default)
                }
                
            case let .showToast(toastInfo):
                state.isSuccessWriteReview = false
                state.currentToast = toastInfo
                return .run { send in
                    try await Task.sleep(for: .seconds(2.0))
                    await send(.hideToast, animation: .default)
                }
                
            case .hideToast:
                state.currentToast = nil
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
                state.reviewPage = 0
                state.originalReviews = []
                state.sortedReviews = []
                state.isLastPage = false
                
                return .concatenate(
                    .send(.loadingStarted),
                    .run { [id = state.id, sort = reviewSort, isUser = state.isUser, token = state.token] send in
                        let startTime = Date()
                        
                        do {
                            let tokenToSend = token.isEmpty ? nil : token
                            let reviewResponse = try await restaurantClient.getReviews(id, 0, sort, isUser, tokenToSend)
                            
                            let elapsed = Date().timeIntervalSince(startTime)
                            if elapsed < 0.5 {
                                try await Task.sleep(for: .seconds(0.5 - elapsed))
                            }
                            
                            await send(.reviewLoaded(reviewResponse.reviews))
                        } catch let error as ReviewError {
                            await send(.reviewError(error))
                        } catch {
                            await send(.reviewError(.unknown))
                        }
                    }
                )

            case let .photoFilterToggled(isOn):
                state.isPhotoFilterOn = isOn
                
                state.reviewPage = 0
                state.originalReviews = []
                state.sortedReviews = []
                state.isLastPage = false
                
                return .concatenate(
                    .send(.loadingStarted),
                    .run { [id = state.id, sort = state.sort, isUser = state.isUser, token = state.token] send in
                        let startTime = Date()
                        
                        do {
                            let tokenToSend = token.isEmpty ? nil : token
                            let reviewResponse = try await restaurantClient.getReviews(id, 0, sort, isUser, tokenToSend)
                            
                            let elapsed = Date().timeIntervalSince(startTime)
                            if elapsed < 0.5 {
                                try await Task.sleep(for: .seconds(0.5 - elapsed))
                            }
                            
                            await send(.reviewLoaded(reviewResponse.reviews))
                        } catch let error as ReviewError {
                            await send(.reviewError(error))
                        } catch {
                            await send(.reviewError(.unknown))
                        }
                    }
                )
                
            case .initailLoadingCompleted:
                state.showSkeletonLoading = false
                return .none
                
            case .loadingStarted:
                state.showSkeletonLoading = true
                return .none
                
            case .loadingFinished:
                state.showSkeletonLoading = false
                return .none
                
            case let .reviewLoaded(review):
                state.originalReviews += review
                state.reviewCount = state.originalReviews.count
                
                // 사진 필터가 켜져있으면 필터링 적용
                let reviewsToSort = state.isPhotoFilterOn
                    ? state.originalReviews.filter { !$0.photoURLs.isEmpty }
                    : state.originalReviews
                
                state.sortedReviews = sortReviews(state.sort, reviewsToSort)
                state.isLastPage = review.count < 10
                state.isReviewLoading = false
                
                // 사진 필터가 켜져있는데 사진이 있는 리뷰가 없고, 마지막 페이지가 아니면 계속 로드
                if state.isPhotoFilterOn, reviewsToSort.isEmpty, !state.isLastPage {
                    state.reviewPage += 1
                    state.isReviewLoading = true
                    
                    return .run { [id = state.id, page = state.reviewPage, sort = state.sort, isUser = state.isUser, token = state.token] send in
                        do {
                            let tokenToSend = token.isEmpty ? nil : token
                            let reviewResponse = try await restaurantClient.getReviews(id, page, sort, isUser, tokenToSend)
                            await send(.reviewLoaded(reviewResponse.reviews))
                        } catch let error as ReviewError {
                            await send(.reviewError(error))
                        } catch {
                            await send(.reviewError(.unknown))
                        }
                    }
                }
                
                return .send(.loadingFinished)
                
            case let .reviewError(error):
                state.isReviewLoading = false
                return .send(.loadingFinished)
                
            case .writeReviewButtonTapped:
                if !state.isUser {
                    state.showLoginAlert = true
                    return .none
                }
                
                return .run { [id = state.id, token = state.token] send in
                    do {
                        try await restaurantClient.checkReviewAvailable(id, token)
                        await send(.reviewAvailabilityChecked)
                    } catch let error as ReviewError {
                        await send(.reviewAvailabilityError(error))
                    } catch {
                        await send(.reviewAvailabilityError(.unknown))
                    }
                }
                
            case let .isSuccessWriteReview(isSuccess):
                state.isSuccessWriteReview = isSuccess
                return .none
                
            case let .reviewWriteCompleted(v):
                if state.isWriteReviewPresented != v {
                    state.isWriteReviewPresented = v
                    state.reviewPage = 0
                }
                
                if !state.isWriteReviewPresented, state.isSuccessWriteReview {
                    let toastInfo = ToastInfo(
                        imageName: "checkWhiteIcon",
                        message: "리뷰 작성을 완료했어요"
                    )
                    
                    state.reviewPage = 0
                    state.originalReviews = []
                    
                    return .run { [id = state.id, page = state.reviewPage, sort = state.sort, isUser = state.isUser, token = state.token] send in
                        
                        do {
                            await send(.showToast(toastInfo))
                            let tokenToSend = token.isEmpty ? nil : token
                            let reviewResponse = try await restaurantClient.getReviews(id, page, sort, isUser, tokenToSend)
                            await send(.reviewLoaded(reviewResponse.reviews))
                            
                        } catch let error as ReviewError {
                            await send(.reviewError(error))
                        } catch {
                            await send(.reviewError(.unknown))
                        }
                    }
                    
                } else {
                    return .none
                }
                
            case .emptyAction:
                return .none
                
            case let .showToolTip(id):
                state.activeToolTipReviewID = id
                return .none

            case .hideToolTip:
                state.activeToolTipReviewID = nil
                return .none

            case let .reviewDeleteButtonTapped(id):
                state.showDeleteAlert = true
                state.reviewToDelete = id
                return .none
                
            case let .reviewDeleteConfirmed(reviewId):
                state.showDeleteAlert = false
                state.reviewToDelete = nil
                return .run { [token = state.token, reviewId = reviewId] send in
                    do {
                        let success = try await restaurantClient.deleteReview(reviewId, token)
                        if success {
                            // 삭제 성공 시 리뷰 목록에서 제거
                            await send(.reviewDeleted(reviewId))
                        }
                    } catch {
                        // 삭제 실패 시 에러 처리
                        await send(.reviewDeleteError(error.localizedDescription))
                    }
                }
                
            case let .showLoginAlert(show):
                state.showLoginAlert = show
                return .none
                

                
            case .reviewAvailabilityChecked:
                state.isWriteReviewPresented = true
                return .none
                
            case let .reviewDeleted(reviewId):
                // 삭제된 리뷰를 목록에서 제거
                state.originalReviews.removeAll { $0.id == reviewId }
                state.sortedReviews.removeAll { $0.id == reviewId }
                state.reviewCount = state.originalReviews.count
                return .none
                
            case let .reviewDeleteError(errorMessage):
                let toastInfo = ToastInfo(
                    imageName: "warnIcon",
                    message: "리뷰 삭제 중 오류가 발생했습니다."
                )
                return .send(.showToast(toastInfo))
                
            case let .reviewAvailabilityError(error):
                let message = error == .alreadyWritten
                    ? "리뷰는 가게 당 한 번만 작성할 수 있어요!"
                    : "리뷰 작성 중 오류가 발생했습니다."
                let toastInfo = ToastInfo(
                    imageName: "trumpetIcon",
                    message: message
                )
                return .send(.showToast(toastInfo))
                
            case .deleteAlertDismissed:
                state.showDeleteAlert = false
                state.reviewToDelete = nil
                return .none
            }
        }
    }
    
    private func sortReviews(_ sort: ReviewSortOption, _ list: [Review]) -> [Review] {
        switch sort {
        case .recent:
            return list.sorted { $0.date > $1.date }

        case .high:
            return list.sorted { $0.star > $1.star }

        case .low:
            return list.sorted { $0.star < $1.star }
        }
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
