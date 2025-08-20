//
//  SearchView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/14/25.
//

import ComposableArchitecture
import SwiftUI

// MARK: - Store List View

struct SearchView: View {
    private let store: StoreOf<SearchFeature>
    private let parentStore: StoreOf<RootFeature>
    @ObservedObject var viewStore: ViewStoreOf<SearchFeature>
    @ObservedObject var parentViewStore: ViewStoreOf<RootFeature>
    
    init(store: StoreOf<SearchFeature>, parentStore: StoreOf<RootFeature>) {
        self.store = store
        self.parentStore = parentStore
        viewStore = ViewStore(store, observe: { $0 })
        parentViewStore = ViewStore(parentStore, observe: { $0 })
    }
    
    var body: some View {
        VStack(spacing: 0) {
            SearchHeaderView(viewStore: viewStore)
            if viewStore.showEptyView {
                SearchEmptyView(viewStore: viewStore)
            } else {
                RecentSearchView(viewStore: viewStore)
                SearchListView(viewStore: viewStore)
            }
        }
        .onAppear {
            viewStore.send(.onAppear)
        }
        .fullScreenCover(
            isPresented: viewStore.binding(
                get: {
                    if case .restrauntDetail = $0.activeScreen { return true }
                    return false
                },
                send: .onDismiss
            )
        ) {
            if case let .restrauntDetail(id) = viewStore.activeScreen {
                DetailView(
                    store: Store(
                        initialState: DetailFeature.State(id: id),
                        reducer: { DetailFeature() },
                        withDependencies: {
                            $0.restaurantClient = RestaurantClient.liveValue
                            $0.keywordClient = KeywordClient.liveValue
                        }
                    ),
                    parentStore: parentStore
                )
                .presentationDragIndicator(.visible)
            }
        }
    }
}
