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
        NavigationStack {
            VStack(spacing: 0) {
                SearchHeaderView(viewStore: viewStore)
                RecentSearchView(viewStore: viewStore)
                SearchListView(viewStore: viewStore)
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
            if case let .restrauntDetail(id) = screen {
                // 상세화면 전환
            }
        }
    }
}
