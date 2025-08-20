//
//  DetailView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/22/25.
//

import ComposableArchitecture
import SwiftUI

struct DetailView: View {
    private let store: StoreOf<DetailFeature>
    private let parentStore: StoreOf<RootFeature>
    @ObservedObject var viewStore: ViewStoreOf<DetailFeature>
    @ObservedObject var parentViewStore: ViewStoreOf<RootFeature>
    
    init(store: StoreOf<DetailFeature>, parentStore: StoreOf<RootFeature>) {
        self.store = store
        self.parentStore = parentStore
        viewStore = ViewStore(store, observe: { $0 })
        parentViewStore = ViewStore(parentStore, observe: { $0 })
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if viewStore.isLoading {
                DetailSkeletonView()
            } else {
                DetailInfoView(viewStore: viewStore)
                DetailTabButtonView(viewStore: viewStore)
                DetailTabView(viewStore: viewStore, parentViewStore: parentViewStore)
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .onAppear {
            viewStore.send(.onAppear)
        }
        .fullScreenCover(
            isPresented: viewStore.binding(
                get: \.isWriteReviewPresented,
                send: { .reviewWriteCompleted($0) }
            )
        ) {
            ReviewMakeView(
                store: Store(
                    initialState: ReviewMakeFeature.State(
                        reviewMode: .create(
                            restaurantName: viewStore.restaurantDetail.name,
                            restaurantID: Int(
                                viewStore.restaurantDetail.id
                            ) ?? 0
                        )
                    ),
                    reducer: {
                        ReviewMakeFeature()
                    }
                ), onComplete: { isWriteSuccess in
                    viewStore.send(.isSuccessWriteReview(isWriteSuccess))
                }
            )
        }
    }
}
