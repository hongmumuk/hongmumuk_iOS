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
                                Text("review_empty_title".localized())
                                    .fontStyle(Fonts.title2Bold)
                                    .foregroundColor(Colors.Label.Normal.strong)
                                Spacer().frame(height: 8)
                                Text("review_empty_message".localized())
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
        .alert("review_delete_confirm_title".localized(), isPresented: viewStore.binding(
            get: \.showDeleteAlert,
            send: .deleteAlertDismissed
        )) {
            Button("cancel".localized(), role: .cancel) {
                viewStore.send(.deleteAlertDismissed)
            }
            Button("common_delete".localized(), role: .destructive) {
                if let reviewId = viewStore.reviewToDelete {
                    viewStore.send(.reviewDeleteConfirmed(reviewId))
                }
            }
        } message: {
            Text("review_delete_confirm_warning".localized())
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
                
                Text("photo_review_only".localized())
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
                Text(viewStore.sort.displayName)
                    .fontStyle(Fonts.body1Medium)
                    .foregroundColor(Colors.Primary.strong)
                
                Spacer()
                    .frame(width: 4)
                
                Image("dropDownBlueIcon")
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
                title: Text("sort_by".localized()),
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
                    Text("review_write_cta".localized())
                        .fontStyle(Fonts.heading2Bold)
                        .foregroundColor(Colors.Primary.strong)
                }
            }
            .padding(.horizontal, 24)
        }
        .alert("review_login_title".localized(), isPresented: viewStore.binding(
            get: \.showLoginAlert,
            send: .showLoginAlert(false)
        )) {
            Button("cancel".localized(), role: .cancel) {
                viewStore.send(.showLoginAlert(false))
            }
            Button("login".localized()) {
                parentViewStore.send(.navigationTo(.emailLogin))
            }
        } message: {
            Text("review_login_message".localized())
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
