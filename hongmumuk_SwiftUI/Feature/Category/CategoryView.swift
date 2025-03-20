//
//  CategoryView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/17/25.
//

import ComposableArchitecture
import SwiftUI

struct CategoryView: View {
    private let store: StoreOf<CategoryFeature>
    @ObservedObject var viewStore: ViewStoreOf<CategoryFeature>
    
    init(store: StoreOf<CategoryFeature>) {
        self.store = store
        viewStore = ViewStore(store, observe: { $0 })
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                CategoryHeaderView(viewStore: viewStore)
                CategoryFilterView(viewStore: viewStore)
                CategoryListView(viewStore: viewStore)
            }
            CategoryRandomButton(viewStore: viewStore)
        }
        .navigationDestination(
            isPresented: viewStore.binding(
                get: { $0.activeScreen == .search },
                send: .onDismiss
            )
        ) {
            SearchView(
                store: Store(
                    initialState: SearchFeature.State(),
                    reducer: { SearchFeature() },
                    withDependencies: {
                        $0.restaurantClient = RestaurantClient.liveValue
                        $0.userDefaultsClient = UserDefaultsClient.liveValue
                    }
                )
            )
            .navigationBarHidden(true)
        }
        .onAppear {
            viewStore.send(.onAppear)
        }
        .sheet(
            isPresented: viewStore.binding(
                get: {
                    if case .restaurantDetail = $0.activeScreen { return true }
                    if case .random = $0.activeScreen { return true }
                    return false
                },
                send: .onDismiss
            )
        ) {
            if case let .restaurantDetail(id) = viewStore.activeScreen {
                DetailView(
                    store: Store(
                        initialState: DetailFeature.State(id: id),
                        reducer: { DetailFeature() },
                        withDependencies: {
                            $0.restaurantClient = RestaurantClient.liveValue
                            $0.keywordClient = KeywordClient.liveValue
                        }
                    )
                )
                .presentationDragIndicator(.visible)
            }
            
            if case .random = viewStore.activeScreen {
                RandomView(
                    store: Store(
                        initialState: RandomFeature.State(),
                        reducer: { RandomFeature() },
                        withDependencies: {
                            $0.restaurantClient = RestaurantClient.liveValue
                        }
                    )
                )
                .presentationDragIndicator(.visible)
            }
        }
    }
}
