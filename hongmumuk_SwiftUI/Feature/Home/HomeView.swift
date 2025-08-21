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
    private let parentStore: StoreOf<RootFeature>
    
    @ObservedObject private var viewStore: ViewStoreOf<HomeFeature>
    @ObservedObject var parentViewStore: ViewStoreOf<RootFeature>
    
    init(
        store: StoreOf<HomeFeature>,
        parentStore: StoreOf<RootFeature>
    ) {
        self.store = store
        self.parentStore = parentStore
        viewStore = ViewStore(store, observe: { $0 })
        parentViewStore = ViewStore(parentStore, observe: { $0 })
    }
    
    var body: some View {
        ZStack {
            HomeHeaderView(viewStore: viewStore, parentViewStore: parentViewStore)
            HomeCircleView(viewStore: viewStore, parentViewStore: parentViewStore)
            HomeRandomButton(viewStore: viewStore)
        }
        .onAppear {
            viewStore.send(.onAppear)
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
                    ),
                    parentStore: parentStore
                )
                .presentationDragIndicator(.visible)
            }
        }
    }
}
