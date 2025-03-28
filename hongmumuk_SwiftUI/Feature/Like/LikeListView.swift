//
//  LikeListView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/18/25.
//

import ComposableArchitecture
import Shimmer
import SwiftUI

struct LikeListView: View {
    @ObservedObject var viewStore: ViewStoreOf<LikeFeature>
    @ObservedObject var parentViewStore: ViewStoreOf<RootFeature>
    
    var body: some View {
        if viewStore.showSkeletonLoading {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(0 ..< 5, id: \.self) { _ in
                        ListItemSkeletonItemView()
                            .shimmering(active: true)
                    }
                }
            }
            .padding(.top, 16)
        } else {
            if viewStore.sortedRestaurantList.isEmpty {
                LikeEmptyView(viewStore: viewStore, parentViewStore: parentViewStore)
            } else {
                VStack(spacing: 0) {
                    LikeFilterView(viewStore: viewStore)
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(viewStore.sortedRestaurantList) { item in
                                ListItemView(item: item, sort: viewStore.sort) {
                                    viewStore.send(.restrauntTapped(id: $0.id))
                                }
                            }
                        }
                    }
                    .padding(.top, 16)
                }
            }
        }
    }
}
