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
    @ObservedObject var viewStore: ViewStoreOf<SearchFeature>
    
    init(store: StoreOf<SearchFeature>) {
        self.store = store
        viewStore = ViewStore(store, observe: { $0 })
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
        .sheet(
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
                            $0.restaurantClient = RestaurantClient.testValue
                            $0.keywordClient = KeywordClient.liveValue
                        }
                    )
                )
                .presentationDragIndicator(.visible)
            }
        }
    }
}
