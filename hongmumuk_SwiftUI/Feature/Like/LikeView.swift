//
//  LikeView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/18/25.
//

import ComposableArchitecture
import SwiftUI

struct LikeView: View {
    private let store: StoreOf<LikeFeature>
    @ObservedObject var viewStore: ViewStoreOf<LikeFeature>
    
    init(store: StoreOf<LikeFeature>) {
        self.store = store
        viewStore = ViewStore(store, observe: { $0 })
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                LikeHeaderView(viewStore: viewStore)
                LikeListView(viewStore: viewStore)
            }
        }
        .onAppear {
            viewStore.send(.onAppear)
        }
        .sheet(
            isPresented: viewStore.binding(
                get: { $0.activeScreen != .none },
                send: .onDismiss
            )
        ) {
            if case let .restaurantDetail(id) = viewStore.activeScreen {
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
