//
//  ListView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/17/25.
//

import ComposableArchitecture
import SwiftUI

struct ListView: View {
    private let store: StoreOf<ListFeature>
    @ObservedObject var viewStore: ViewStoreOf<ListFeature>
    
    init(store: StoreOf<ListFeature>) {
        self.store = store
        viewStore = ViewStore(store, observe: { $0 })
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0) {
                    ListHeaderView(viewStore: viewStore)
                    ListFilterView(viewStore: viewStore)
                    ListCategoryView(viewStore: viewStore)
                }
                ListRandomButton(viewStore: viewStore)
            }
        }
        .onAppear {
            viewStore.send(.onAppear)
        }
        .navigationDestination(
            isPresented: viewStore.binding(
                get: { $0.activeScreen != .none },
                send: .onDismiss
            )
        ) {
            let screen = viewStore.activeScreen
            if case .random = screen {
                // random View
            } else if case .search = screen {
                SearchView(
                    store: Store(
                        initialState: SearchFeature.State(),
                        reducer: { SearchFeature() },
                        withDependencies: {
                            $0.restaurantClient = RestaurantClient.testValue
                            $0.userDefaultsClient = UserDefaultsClient.liveValue
                        }
                    )
                )
                .navigationBarHidden(true)
                
            } else if case let .restrauntDetail(id) = screen {
                // 상세화면 전환
            }
        }
    }
}
