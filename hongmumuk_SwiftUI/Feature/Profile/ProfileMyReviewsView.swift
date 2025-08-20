//
//  ProfileMyReviewsView.swift
//  hongmumuk_SwiftUI
//
//  Created by Assistant on 8/6/25.
//

import ComposableArchitecture
import SwiftUI

struct ProfileMyReviewsView: View {
    private let store: StoreOf<ProfileFeature>
    private let parentStore: StoreOf<RootFeature>
    
    @ObservedObject var viewStore: ViewStoreOf<ProfileFeature>
    @ObservedObject var parentViewStore: ViewStoreOf<RootFeature>
    
    init(store: StoreOf<ProfileFeature>, parentStore: StoreOf<RootFeature>) {
        self.store = store
        self.parentStore = parentStore
        
        viewStore = ViewStore(store, observe: { $0 })
        parentViewStore = ViewStore(parentStore, observe: { $0 })
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                WebViewHeader(title: "내 리뷰", showBottomLine: false, parentViewStore: parentViewStore)
                
                // 필터 및 정렬
                filterSortView
                
                // 리뷰 목록
                if viewStore.isReviewsLoading {
                    loadingView
                } else if viewStore.reviews.isEmpty {
                    emptyView
                } else {
                    reviewListView
                }
            }
            
            // 토스트 메시지
            ToastView(
                imageName: viewStore.currentToast?.imageName ?? "",
                title: viewStore.currentToast?.message ?? ""
            )
            .frame(minWidth: UIScreen.main.bounds.width - 120)
            .padding(.bottom, 100)
            .opacity(viewStore.currentToast != nil ? 1.0 : 0.0)
            .scaleEffect(viewStore.currentToast != nil ? 1.0 : 0.8)
            .animation(.easeInOut(duration: 0.3), value: viewStore.currentToast != nil)
        }
        .onAppear {
            viewStore.send(.onAppear)
        }
    }
    
    // MARK: - 필터 및 정렬

    private var filterSortView: some View {
        VStack {
            HStack {
                filterView
                Spacer()
                sortView
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
            
            categoryFilterView
                .padding(.horizontal, 24)
        }
    }

    // MARK: - 개수 뷰

    private var filterView: some View {
        HStack {
            Text(countText)
                .fontStyle(Fonts.body1Medium)
                .foregroundColor(Colors.Label.Normal.neutral)
        }
    }

    private var countText: String {
        let isKorean = Locale.preferredLanguages.first?.hasPrefix("ko") == true
        return isKorean ? "\(viewStore.totalCount)개" : "\(viewStore.totalCount) reviews"
    }

    // MARK: - 정렬 뷰

    private var sortView: some View {
        Button(action: {
            viewStore.send(.sortSheetTapped)
        }) {
            HStack(spacing: 4) {
                Text(viewStore.sortOption.displayName)
                    .fontStyle(Fonts.body1SemiBold)
                    .foregroundColor(Colors.Primary.strong)
                
                Image("dropDownIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
            }
        }
        .actionSheet(isPresented: Binding(
            get: { viewStore.state.showSortSheet },
            set: { newValue in
                if !newValue {
                    viewStore.send(.sortSheetDismissed)
                }
            }
        )) {
            let removeCurrentSort = viewStore.sortOptions.filter { $0 != viewStore.sortOption }
            var buttons: [ActionSheet.Button] = removeCurrentSort.map { sort in
                .default(Text(sort.displayName)) {
                    viewStore.send(.sortChanged(sort))
                }
            }
            buttons.append(.cancel(Text("취소")))
            return ActionSheet(title: Text("정렬 기준"), buttons: buttons)
        }
    }

    // MARK: - 카테고리 필터 뷰

    private var categoryFilterView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(viewStore.categories, id: \.self) { category in
                    Button(action: {
                        viewStore.send(.categoryChanged(category))
                    }) {
                        Text(category.displayName)
                            .fontStyle(Fonts.body1SemiBold)
                            .foregroundColor(viewStore.selectedCategory == category ? Colors.Label.white : Colors.Label.Normal.alternative)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(viewStore.selectedCategory == category ? Colors.Primary.normal : Colors.Label.Normal.disable)
                            )
                    }
                }
            }
        }
    }
    
    // MARK: - 로딩 뷰

    private var loadingView: some View {
        VStack {
            Spacer()
            ProgressView()
                .scaleEffect(1.2)
            Spacer()
        }
    }
    
    // MARK: - 빈 상태 뷰

    private var emptyView: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Image("emptyIcon")
                .resizable()
                .frame(width: 120, height: 120)
            
            Text("작성한 리뷰가 없습니다")
                .fontStyle(Fonts.title2Bold)
                .foregroundColor(Colors.GrayScale.grayscale95)
            
            Text("맛집을 방문하고 첫 리뷰를 작성해보세요")
                .fontStyle(Fonts.body1SemiBold)
                .foregroundColor(Colors.GrayScale.alternative)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding(.horizontal, 24)
    }
    
    // MARK: - 리뷰 목록

    private var reviewListView: some View {
        ScrollView {
            LazyVStack {
                ForEach(Array(viewStore.reviews.enumerated()), id: \.offset) { index, review in
                    Spacer()
                        .frame(height: 24)
                    
                    Button(action: {
                        // TODO: - rid 받아서
                    }) {
                        HStack(spacing: 4) {
                            Text(review.restaurantName?.localized() ?? "")
                                .fontStyle(Fonts.heading2Bold)
                                .foregroundStyle(Colors.Label.Normal.strong)
                            
                            Image("rightArrowIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Spacer()
                        .frame(height: 10)

                    ReviewItemView<ProfileFeature>(
                        item: review,
                        isLast: index == viewStore.reviews.count - 1,
                        showDeleteButton: true,
                        showBadge: false,
                        activeToolTipReviewID: nil,
                        onDeleteTapped: { reviewId in
                            viewStore.send(.reviewDeleteTapped(reviewId))
                        },
                        onToolTipToggled: { _ in
                        }
                    )
                    .padding(.horizontal, 24)
                }
                
                Spacer()
                
                if viewStore.isLoadingMore {
                    HStack {
                        Spacer()
                        ProgressView()
                            .padding()
                        Spacer()
                    }
                }
                
                detectScrollView
            }
            .padding(.vertical, 16)
        }
        .id(viewStore.listId) // 뷰 강제 새로고침
    }
    
    // MARK: - 페이징 감지 뷰

    private var detectScrollView: some View {
        GeometryReader { geo in
            Color.clear
                .frame(height: 1)
                .onAppear {
                    let minY = geo.frame(in: .global).minY
                    let screenHeight = UIScreen.main.bounds.height
                    
                    if minY < screenHeight + 50 {
                        if viewStore.hasMorePages, !viewStore.isReviewsLoading {
                            viewStore.send(.onNextPage)
                        }
                    }
                }
        }
        .frame(height: 1)
    }
}
