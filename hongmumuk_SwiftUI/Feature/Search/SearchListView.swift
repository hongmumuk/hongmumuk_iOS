//
//  SearchListView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/15/25.
//

import ComposableArchitecture
import Shimmer
import SwiftUI

struct SearchListView: View {
    @ObservedObject var viewStore: ViewStoreOf<SearchFeature>
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                if viewStore.isLoading {
                    ForEach(0 ..< 5, id: \.self) { _ in
                        ListItemSkeletonItemView()
                            .shimmering(active: true)
                    }
                } else {
                    ForEach(viewStore.searchedList) { item in
                        ListItemView(item: item, sort: .likes) { viewStore.send(.restrauntTapped(id: $0.id)) }
                    }
                }
            }
        }
        .scrollDismissesKeyboard(.immediately)
        .padding(.top, 16)
    }
}
