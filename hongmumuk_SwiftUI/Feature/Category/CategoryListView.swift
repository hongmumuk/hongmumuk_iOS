//
//  CategoryListView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/17/25.
//

import ComposableArchitecture
import Shimmer
import SwiftUI

struct CategoryListView: View {
    @ObservedObject var viewStore: ViewStoreOf<CategoryFeature>
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                if viewStore.showSkeletonLoading {
                    ForEach(0 ..< 5, id: \.self) { _ in
                        ListItemSkeletonItemView()
                            .shimmering(active: true)
                    }
                } else {
                    ForEach(viewStore.sortedRestaurantList) { item in
                        ListItemView(item: item, sort: viewStore.sort) {
                            viewStore.send(.restaurantTapped(id: $0.id))
                        }
                    }
                    if !viewStore.isLastPage {
                        ProgressView()
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    viewStore.send(.onNextPage)
                                }
                            }
                    } else {
                        InquiryButton {
                            viewStore.send(.inquryButtonTapped)
                        }
                        .padding(.top, 72)
                        .padding(.bottom, 117)
                    }
                }
            }
        }
        .scrollDismissesKeyboard(.immediately)
        .padding(.top, 16)
    }
}
