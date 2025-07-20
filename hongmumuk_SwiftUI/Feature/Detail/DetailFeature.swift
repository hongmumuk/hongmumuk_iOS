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
        
        case showToolTip(id: Int)
        case hideToolTip
        
        // review 작성하는 것과 관련된 액션
        case writeReviewButtonTapped
        case reviewWriteCompleted
        case showLoginAlert(Bool)
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
                    
                    // 리뷰는 목업 데이터로 설정 (페이지네이션 없이 모든 리뷰 표시)
                    let mockReviews = createMockReviews()
                    return .run { send in
                        await send(.reviewLoaded(mockReviews))
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
                
                // 리뷰는 목업 데이터로 설정
                let mockReviews = createMockReviews()
                return .run { send in
                    await send(.reviewLoaded(mockReviews))
                }
                
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
                state.reviewPage = 0
                state.originalReviews = []
                state.sortedReviews = []
                state.isLastPage = false
                
                // 리뷰는 목업 데이터로 설정
                let mockReviews = createMockReviews()
                return .run { send in
                    await send(.reviewLoaded(mockReviews))
                }

            case let .photoFilterToggled(isOn):
                state.isPhotoFilterOn = isOn
                let filtered = isOn
                    ? state.originalReviews.filter { !$0.photoURLs.isEmpty }
                    : state.originalReviews
                state.sortedReviews = sortReviews(state.sort, filtered)
                state.reviewCount = filtered.count
                return .none
                
            case .initailLoadingCompleted:
                state.showSkeletonLoading = false
                return .none
                
            case let .reviewLoaded(review):
                state.originalReviews += review
                state.reviewCount = state.originalReviews.count
                state.sortedReviews = sortReviews(state.sort, state.originalReviews)
                state.isLastPage = review.count < 10
                state.isReviewLoading = false
                return .none
                
            case let .reviewError(error):
                state.isReviewLoading = false
                return .none
                
            case .writeReviewButtonTapped:
                if !state.isUser {
                    state.showLoginAlert = true
                    return .none
                }
                state.isWriteReviewPresented = true
                return .none
                
            case .reviewWriteCompleted:
                state.isWriteReviewPresented = false
                state.reviewPage = 0
                return /* fetchReviews(for: state) */ .none
                
            case let .showToolTip(id):
                state.activeToolTipReviewID = id
                return .none

            case .hideToolTip:
                state.activeToolTipReviewID = nil
                return .none
            
            case let .reviewEditButtonTapped(id):
                // TODO: 수정 로직 추가
                return .none

            case let .reviewDeleteButtonTapped(id):
                // TODO: 삭제 로직 추가
                return .none
                
            case let .showLoginAlert(show):
                state.showLoginAlert = show
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
    
    private func createMockReviews() -> [Review] {
        return [
            Review(
                id: 1,
                user: "세영이",
                date: "2025-06-20",
                visitCount: 2,
                star: 4,
                content: "제육볶음 정말 맛있어요! 재방문 의사 100%",
                isOwner: false,
                photoURLs: [
                    "https://example.com/photo1.jpg",
                    "https://example.com/photo2.jpg",
                    "https://example.com/photo3.jpg"
                ],
                badge: .newbie
            ),
            Review(
                id: 2,
                user: "도연",
                date: "2025-06-21",
                visitCount: 1,
                star: 5,
                content: "가성비 최고예요. 반찬 구성도 알차고 사장님도 친절해요.",
                isOwner: false,
                photoURLs: [],
                badge: .explorer
            ),
            Review(
                id: 3,
                user: "맛집헌터",
                date: "2025-06-22",
                visitCount: 3,
                star: 4,
                content: "맛도 좋고 양도 푸짐했어요. 점심시간엔 줄이 길 수 있어요.",
                isOwner: false,
                photoURLs: ["https://example.com/photo4.jpg"],
                badge: .foodie
            ),
            Review(
                id: 4,
                user: "식당주인",
                date: "2025-06-23",
                visitCount: 100,
                star: 5,
                content: "사장입니다 :) 항상 좋은 재료로 정성껏 만들고 있어요!",
                isOwner: true,
                photoURLs: [],
                badge: .master
            ),
            Review(
                id: 5,
                user: "카메라장인",
                date: "2025-06-24",
                visitCount: 1,
                star: 5,
                content: "비주얼이 정말 예술이에요! 사진 맛집 인정합니다.",
                isOwner: false,
                photoURLs: [
                    "https://example.com/photo5_1.jpg",
                    "https://example.com/photo5_2.jpg",
                    "https://example.com/photo5_3.jpg",
                    "https://example.com/photo5_4.jpg"
                ],
                badge: .newbie
            )
        ] + (6 ... 30).map {
            Review(
                id: $0,
                user: "유저\($0)",
                date: "2025-06-\(String(format: "%02d", ($0 % 30) + 1))",
                visitCount: Int.random(in: 1 ... 5),
                star: Int.random(in: 3 ... 5),
                content: "리뷰 내용 \($0): 이 집 괜찮아요~",
                isOwner: false,
                photoURLs: $0 % 3 == 0 ? ["https://example.com/photo\($0).jpg"] : [],
                badge: $0 % 5 == 0 ? .explorer : .newbie
            )
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
