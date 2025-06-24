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
    
    var body: some View {
        VStack(alignment: .leading) {
            // 목록
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    Spacer()
                        .frame(height: 20)
                    
                    headerView
                    
                    Spacer()
                        .frame(height: 20)
                    
                    writeReviewButton
                        .frame(height: 60)
                    
                    Spacer()
                        .frame(height: 16)
                    
                    ForEach(Array(viewStore.sortedReviews.enumerated()), id: \.element.id) { index, item in
                        DetailReviewItemView(item: item, isLast: index == viewStore.sortedReviews.count - 1, viewStore: viewStore)
                            .padding(.horizontal, 24)
                    }
                    
                    if !viewStore.isLastPage, viewStore.isReviewLoading {
                        HStack {
                            Spacer()
                            ProgressView()
                                .padding()
                            Spacer()
                        }
                    }
                    
                    detectScrollView
                }
            }
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
                    ? Image("photoFilterIconBlue")
                    : Image("photoFilterIcon"))
                    .frame(width: 20, height: 20)
                
                Spacer()
                    .frame(width: 4)
                
                // TODO: 로컬라이즈드
                Text("사진 리뷰만")
                    .fontStyle(Fonts.body1Medium)
                    .foregroundColor(viewStore.isPhotoFilterOn ? Colors.Primary.strong : Colors.GrayScale.alternative)
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
            if viewStore.canWriteReview {
                viewStore.send(.writeReviewButtonTapped)
            }
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(viewStore.canWriteReview ? Colors.Primary.primary10 : Colors.GrayScale.grayscale10)

                HStack {
                    Image(viewStore.canWriteReview ? "penIcon" : "penDisabledIcon")
                        .frame(width: 20, height: 20)

                    Spacer().frame(width: 8)

                    Text(viewStore.canWriteReview ? "리뷰 작성하기" : "작성 불가")
                        .fontStyle(Fonts.heading2Bold)
                        .foregroundColor(viewStore.canWriteReview ? Colors.Primary.strong : Colors.GrayScale.grayscale50)
                }
            }
            .padding(.horizontal, 24)
        }
        .disabled(!viewStore.canWriteReview)
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
