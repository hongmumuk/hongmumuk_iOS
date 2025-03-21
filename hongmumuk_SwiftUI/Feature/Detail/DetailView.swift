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
    @ObservedObject var viewStore: ViewStoreOf<DetailFeature>
    
    init(store: StoreOf<DetailFeature>) {
        self.store = store
        viewStore = ViewStore(store, observe: { $0 })
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if viewStore.isLoading {
                DetailSkeletonView()
            } else {
                DetailInfoView(viewStore: viewStore)
                DetailTabButtonView(viewStore: viewStore)
                DetailTabView(viewStore: viewStore)
            }
        }
        .onAppear {
            viewStore.send(.onAppear)
        }
    }
}
