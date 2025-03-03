//
//  HomeView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/4/25.
//

import ComposableArchitecture
import SwiftUI

struct HomeView: View {
    private let store: StoreOf<HomeFeature>
    @ObservedObject private var viewStore: ViewStoreOf<HomeFeature>
    
    init(store: StoreOf<HomeFeature>) {
        self.store = store
        viewStore = ViewStore(store, observe: { $0 })
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                HomeHeaderView(viewStore: viewStore)
                HomeCircleView(viewStore: viewStore)
                HomeRandomButton(viewStore: viewStore)
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
            .navigationDestination(
                isPresented: viewStore.binding(
                    get: { $0.activeScreen != .none && $0.activeScreen != .random },
                    send: .onDismiss
                )
            ) {
                let screen = viewStore.activeScreen
                if case .search = screen {
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
                    
                } else if case let .cateogryList(category) = screen {
                    CategoryView(
                        store: Store(
                            initialState: CategoryFeature.State(
                                cateogry: category
                            ),
                            reducer: { CategoryFeature() },
                            withDependencies: {
                                $0.restaurantClient = RestaurantClient.liveValue
                            }
                        )
                    )
                    .navigationBarHidden(true)
                }
            }
        }
        .sheet(
            isPresented: viewStore.binding(
                get: { $0.activeScreen == .random },
                send: .onDismiss
            )
        ) {
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
