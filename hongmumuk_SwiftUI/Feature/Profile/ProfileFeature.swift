//
//  ProfileFeature.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 3/6/25.
//

import ComposableArchitecture
import SwiftUI

// 프로필 리뷰 정렬 옵션
enum ProfileReviewSort: String, CaseIterable {
    case recent = "new"
    case old
    
    var displayName: String {
        switch self {
        case .recent: return "sort_by_newest".localized()
        case .old: return "sort_by_oldest".localized()
        }
    }
}

struct ProfileFeature: Reducer {
    struct State: Equatable {
        var isUser = false
        var token: String = ""
        var currentVersion = ""
        var currentLang = ""
        var showLoginAlert = false
        var showLangAlert = false
        
        // 내 리뷰 관련 상태
        var allReviews: [Review] = [] // 모든 리뷰 (필터링 전)
        var reviews: [Review] = [] // 필터링된 리뷰
        var totalCount: Int = 0
        var selectedCategory: Category = .all
        var categories: [Category] = Category.allCases
        var sortOption: ProfileReviewSort = .recent
        var sortOptions: [ProfileReviewSort] = ProfileReviewSort.allCases
        var currentPage: Int = 0
        var hasMorePages: Bool = true
        var isLoadingMore: Bool = false
        var isReviewsLoading: Bool = false
        var reviewsErrorMessage: String? = nil
        var showSortSheet: Bool = false // 추가
        var listId: UUID = .init() // 뷰 강제 새로고침을 위한 ID
        var currentToast: ToastInfo? = nil // 토스트 메시지
        var showDeleteAlert: Bool = false 
        var reviewToDelete: Int? = nil
    }
    
    enum Action: Equatable {
        case onAppear
        case onDismiss
        case checkUser(String?)
        case loginButtonTapped
        case langButtonTapped
        case loginAlertDismissed
        case langAlertDismissed
        case inquryButtonTapped
        
        // 내 리뷰 관련 액션
        case reviewsLoaded(TaskResult<[Review]>)
        case loadMoreReviews
        case onNextPage // 페이징 액션 추가
        case categoryChanged(Category)
        case sortChanged(ProfileReviewSort)
        case reviewDeleteTapped(Int)
        case reviewDeleteConfirmed(Int)
        case reviewDeleted(Int)
        case reviewDeleteError(String)
        case clearReviewsError
        case sortSheetTapped // 추가
        case sortSheetDismissed // 추가
        case showToast(ToastInfo)
        case hideToast
        case deleteAlertDismissed
        case restaurantNavigationTapped(Int)
    }
    
    @Dependency(\.keychainClient) var keychainClient
    @Dependency(\.restaurantClient) var restaurantClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.currentVersion = "v" + Bundle.main.fullVersion
                state.currentLang = "current_lang".localized()
                
                return .run { send in
                    let token = await keychainClient.getString(.accessToken)
                    await send(.checkUser(token))
                }
                
            case .onDismiss:
                return .none
                
            case let .checkUser(token):
                if let token {
                    state.isUser = true
                    state.token = token
                    // 사용자가 로그인되어 있으면 리뷰 로딩 시작
                    return .run { [token = token, sort = state.sortOption] send in
                        let result = await TaskResult {
                            try await restaurantClient.getMyReviews(0, sort.rawValue, token)
                        }
                        await send(.reviewsLoaded(result))
                    }
                }
                return .none
                
            case .loginButtonTapped:
                state.showLoginAlert = true
                return .none
                
            case .langButtonTapped:
                state.showLangAlert = true
                return .none
                
            case .loginAlertDismissed:
                state.showLoginAlert = false
                return .none
                
            case .langAlertDismissed:
                state.showLangAlert = false
                return .none
                
            case .inquryButtonTapped:
                if let url = URL(string: "https://forms.gle/e8X1RPPJCDWkwj5JA") {
                    UIApplication.shared.open(url)
                }
                return .none
                
            // 내 리뷰 관련 액션 처리
            case let .reviewsLoaded(.success(reviews)):
                if state.currentPage == 0 {
                    // 첫 페이지 로드
                    state.allReviews = reviews
                    
                    // 실제로 존재하는 카테고리만 필터링
                    let existingCategories = Set(reviews.compactMap(\.category))
                    let availableCategories: [Category] = Category.allCases.filter { category in
                        if category == .all { return true } // "전체"는 항상 포함
                        return existingCategories.contains(category.rawValue.uppercased())
                    }
                    state.categories = availableCategories
                    
                    // 만약 현재 선택된 카테고리가 사용 가능한 카테고리에 없다면 "전체"로 변경
                    if !availableCategories.contains(state.selectedCategory) {
                        state.selectedCategory = .all
                    }
                } else {
                    // 추가 페이지 로드
                    state.allReviews += reviews
                }
                
                // 선택된 카테고리에 따라 필터링
                if state.selectedCategory == .all {
                    state.reviews = state.allReviews
                } else {
                    state.reviews = state.allReviews.filter { review in
                        review.category?.uppercased() == state.selectedCategory.rawValue.uppercased()
                    }
                }
                
                state.totalCount = state.reviews.count
                
                // 마지막 페이지 여부 확인 (10개 미만이면 마지막 페이지)
                state.hasMorePages = reviews.count >= 10
                state.isReviewsLoading = false
                state.isLoadingMore = false
                return .none
                
            case let .reviewsLoaded(.failure(error)):
                state.reviewsErrorMessage = error.localizedDescription
                state.isReviewsLoading = false
                return .none
                
            case .loadMoreReviews:
                if state.hasMorePages, !state.isLoadingMore {
                    state.isLoadingMore = true
                    state.currentPage += 1
                    return .run { [token = state.token, page = state.currentPage, sort = state.sortOption] send in
                        let result = await TaskResult {
                            try await restaurantClient.getMyReviews(page, sort.rawValue, token)
                        }
                        await send(.reviewsLoaded(result))
                    }
                }
                return .none
                
            case .onNextPage:
                if state.hasMorePages, !state.isReviewsLoading {
                    state.isReviewsLoading = true
                    state.currentPage += 1
                    return .run { [token = state.token, page = state.currentPage, sort = state.sortOption] send in
                        let result = await TaskResult {
                            try await restaurantClient.getMyReviews(page, sort.rawValue, token)
                        }
                        await send(.reviewsLoaded(result))
                    }
                }
                return .none
                
            case let .categoryChanged(category):
                state.selectedCategory = category
                
                // 선택된 카테고리에 따라 필터링
                if category == .all {
                    state.reviews = state.allReviews
                } else {
                    state.reviews = state.allReviews.filter { review in
                        review.category?.uppercased() == category.rawValue.uppercased()
                    }
                }
                
                state.totalCount = state.reviews.count
                return .none
                
            case let .sortChanged(sort):
                state.sortOption = sort
                state.currentPage = 0 // 정렬 변경 시 페이지 리셋
                state.allReviews = [] // 기존 데이터 초기화
                state.listId = UUID() // 뷰 강제 새로고침
                state.isReviewsLoading = true
                
                return .run { [token = state.token, sort = sort] send in
                    let result = await TaskResult {
                        try await restaurantClient.getMyReviews(0, sort.rawValue, token)
                    }
                    await send(.reviewsLoaded(result))
                }
                
            case let .reviewDeleteTapped(reviewId):
                state.showDeleteAlert = true
                state.reviewToDelete = reviewId
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
                
            case let .reviewDeleted(reviewId):
                // 삭제된 리뷰를 목록에서 제거
                state.allReviews.removeAll { $0.id == reviewId }
                state.reviews.removeAll { $0.id == reviewId }
                state.totalCount = state.reviews.count
                return .none
                
            case let .reviewDeleteError(errorMessage):
                let toastInfo = ToastInfo(
                    imageName: "warnIcon",
                    message: "review_delete_error_title".localized()
                )
                return .send(.showToast(toastInfo))
                
            case .clearReviewsError:
                state.reviewsErrorMessage = nil
                return .none

            case .sortSheetTapped:
                state.showSortSheet = true
                return .none

            case .sortSheetDismissed:
                state.showSortSheet = false
                return .none
                
            case let .showToast(toastInfo):
                state.currentToast = toastInfo
                return .run { send in
                    try await Task.sleep(for: .seconds(3))
                    await send(.hideToast)
                }
                
            case .hideToast:
                state.currentToast = nil
                return .none
                
            case .deleteAlertDismissed:
                state.showDeleteAlert = false
                state.reviewToDelete = nil
                return .none
                
            case let .restaurantNavigationTapped(_):
                return .none
            }
        }
    }
}
