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
    private let parentStore: StoreOf<RootFeature>
    
    @ObservedObject var viewStore: ViewStoreOf<LikeFeature>
    @ObservedObject var parentViewStore: ViewStoreOf<RootFeature>
    
    init(store: StoreOf<LikeFeature>, parentStore: StoreOf<RootFeature>) {
        self.store = store
        self.parentStore = parentStore
        
        viewStore = ViewStore(store, observe: { $0 })
        parentViewStore = ViewStore(parentStore, observe: { $0 })
    }
    
    var body: some View {
        VStack(spacing: 0) {
            LikeHeaderView(viewStore: viewStore)
            LikeListView(viewStore: viewStore, parentViewStore: parentViewStore)
        }
        .onAppear {
            viewStore.send(.onAppear)
        }
        .fullScreenCover(
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
                            $0.restaurantClient = RestaurantClient.liveValue
                            $0.keywordClient = KeywordClient.liveValue
                        }
                    )
                )
                .presentationDragIndicator(.visible)
            }
        }
    }
}
