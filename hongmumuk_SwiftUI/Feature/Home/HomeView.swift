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
        ZStack {
            HomeHeaderView(viewStore: viewStore)
            HomeCircleView(viewStore: viewStore)
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
                    )
                )
                .presentationDragIndicator(.visible)
            }
        }
    }
}
