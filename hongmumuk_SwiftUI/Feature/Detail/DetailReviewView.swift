//
//  DetailReviewView.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 6/24/25.
//

import ComposableArchitecture
import SwiftUI

struct DetailReviewView: View {
    @ObservedObject var viewStore: ViewStoreOf<DetailFeature>
    @ObservedObject var parentViewStore: ViewStoreOf<RootFeature>
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 0) {
                        Spacer().frame(height: 20)
                        headerView
                        Spacer().frame(height: 20)
                        writeReviewButton.frame(height: 60)
                        Spacer().frame(height: 16)
                        
                        if viewStore.showSkeletonLoading || viewStore.sortedReviews.isEmpty && viewStore.isReviewLoading {
                            VStack(spacing: 16) {
                                ForEach(0 ..< 3, id: \.self) { _ in
                                    ReviewSkeletonView()
                                }
                            }
                        } else if viewStore.sortedReviews.isEmpty {
                            VStack(alignment: .center) {
                                Spacer()
                                    .frame(height: 62)
                                Image("emptyIcon")
                                    .resizable()
                                    .frame(width: 180, height: 180)
                                Spacer().frame(height: 12)
                                Text("작성된 리뷰가 없습니다.")
                                    .fontStyle(Fonts.title2Bold)
                                    .foregroundColor(Colors.Label.Normal.strong)
                                Spacer().frame(height: 8)
                                Text("첫 리뷰를 작성해 보세요")
                                    .fontStyle(Fonts.heading2Bold)
                                    .foregroundColor(Colors.Label.Normal.alternative)
                                Spacer()
                            }
                            .frame(maxWidth: .infinity)
                            .contentShape(Rectangle())
                        } else {
                            ForEach(Array(viewStore.sortedReviews.enumerated()), id: \.offset) { index, item in
                                DetailReviewItemView(item: item, isLast: index == viewStore.sortedReviews.count - 1, viewStore: viewStore)
                                    .padding(.horizontal, 24)
                            }
                            if !viewStore.isLastPage, viewStore.isReviewLoading {
                                HStack {
                                    Spacer()
                                    ProgressView().padding()
                                    Spacer()
                                }
                            }
                        }
                        detectScrollView
                    }
                }
                .coordinateSpace(name: "scrollView")
            }
            
            // 툴팁 외부 클릭 시 사라지는 오버레이
            if viewStore.activeToolTipReviewID != nil {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewStore.send(.hideToolTip)
                    }
                    .ignoresSafeArea()
                    .zIndex(999)
            }
        }
        .alert("리뷰를 삭제하시겠습니까?", isPresented: viewStore.binding(
            get: \.showDeleteAlert,
            send: .deleteAlertDismissed
        )) {
            Button("취소", role: .cancel) {
                viewStore.send(.deleteAlertDismissed)
            }
            Button("삭제", role: .destructive) {
                if let reviewId = viewStore.reviewToDelete {
                    viewStore.send(.reviewDeleteConfirmed(reviewId))
                }
            }
        } message: {
            Text("삭제된 리뷰는 복구할 수 없습니다.")
        }
    }
    
    private var headerView: some View {
        HStack {
            photoFilterButton
            Spacer()
            sortButton
        }
        .padding(.horizontal, 24)
    }
    
    private var photoFilterButton: some View {
        HStack {
            Button(action: {
                viewStore.send(.photoFilterToggled(!viewStore.isPhotoFilterOn))
            }) {
                (viewStore.isPhotoFilterOn
                    ? Image("photoFilterIconOn")
                    : Image("photoFilterIcon"))
                    .resizable()
                    .frame(width: 20, height: 20)
                
                Spacer()
                    .frame(width: 4)
                
                // TODO: 로컬라이즈드
                Text("사진 리뷰만")
                    .fontStyle(Fonts.body1Medium)
                    .foregroundColor(Colors.GrayScale.neutral)
            }
        }
    }
    
    private var sortButton: some View {
        Button(action: {
            viewStore.send(.sortButtonTapped)
        }) {
            HStack {
                // TODO: 로컬라이즈드
                Text(viewStore.sort.displayName)
                    .fontStyle(Fonts.body1Medium)
                    .foregroundColor(Colors.Primary.strong)
                
                Spacer()
                    .frame(width: 4)
                
                Image("dropDownIcon")
                    .frame(width: 16, height: 16)
            }
        }
        .actionSheet(isPresented: Binding(
            get: { viewStore.showSortSheet },
            set: { newValue in
                if !newValue {
                    viewStore.send(.onDismiss)
                }
            }
        )) {
            let removeCurrentSort = ReviewSortOption.allCases.filter { $0 != viewStore.sort }
            
            var buttons: [ActionSheet.Button] = removeCurrentSort.map { sort in
                .default(Text("\(sort.displayName)")) {
                    viewStore.send(.sortChanged(sort))
                }
            }
            
            buttons.append(.cancel(Text("cancel".localized()), action: {
                viewStore.send(.onDismiss)
            }))
            
            return ActionSheet(
                // TODO: 로컬라이즈드
                title: Text("정렬 기준"),
                buttons: buttons
            )
        }
    }
    
    private var writeReviewButton: some View {
        Button(action: {
            viewStore.send(.writeReviewButtonTapped)
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Colors.Primary.primary10)
                HStack {
                    Image("penIcon")
                        .frame(width: 20, height: 20)
                    Spacer().frame(width: 8)
                    Text("리뷰 작성하기")
                        .fontStyle(Fonts.heading2Bold)
                        .foregroundColor(Colors.Primary.strong)
                }
            }
            .padding(.horizontal, 24)
        }
        .alert("리뷰를 쓰려면 로그인이 필요합니다", isPresented: viewStore.binding(
            get: \.showLoginAlert,
            send: .showLoginAlert(false)
        )) {
            Button("취소", role: .cancel) {
                viewStore.send(.showLoginAlert(false))
            }
            Button("로그인") {
                parentViewStore.send(.navigationTo(.emailLogin))
            }
        } message: {
            Text("로그인 후 리뷰를 작성할 수 있습니다")
        }
    }
    
    private var detectScrollView: some View {
        GeometryReader { geo in
            Color.clear
                .frame(height: 1)
                .onAppear {
                    let minY = geo.frame(in: .global).minY
                    let screenHeight = UIScreen.main.bounds.height
                    
                    if minY < screenHeight + 50 {
                        if !viewStore.isLastPage, !viewStore.isReviewLoading {
                            viewStore.send(.onNextPage)
                        }
                    }
                }
        }
        .frame(height: 1)
    }
}
