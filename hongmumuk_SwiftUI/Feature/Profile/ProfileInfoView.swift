//
//  ProfileInfoView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 3/7/25.
//

import SwiftUI

import ComposableArchitecture

struct ProfileInfoView: View {
    private let store: StoreOf<ProfileInfoFeature>
    private let parentStore: StoreOf<RootFeature>
    
    @ObservedObject var viewStore: ViewStoreOf<ProfileInfoFeature>
    @ObservedObject var parentViewStore: ViewStoreOf<RootFeature>
    
    init(store: StoreOf<ProfileInfoFeature>, parentStore: StoreOf<RootFeature>) {
        self.store = store
        self.parentStore = parentStore
        
        viewStore = ViewStore(store, observe: { $0 })
        parentViewStore = ViewStore(parentStore, observe: { $0 })
    }

    var body: some View {
        VStack {
            WebViewHeader(title: "내정보", showBottomLine: false, parentViewStore: parentViewStore)
            ProfileInfoTapButtonView(viewStore: viewStore)
            ProfileInfoTapView(viewStore: viewStore, parentViewStore: parentViewStore)
        }
        .onAppear {
            viewStore.send(.onAppear)
        }
    }
}
