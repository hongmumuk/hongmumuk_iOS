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
