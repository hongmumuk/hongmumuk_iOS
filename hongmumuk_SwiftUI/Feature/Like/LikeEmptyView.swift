//
//  LikeEmptyView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 3/3/25.
//

import SwiftUI

import ComposableArchitecture

struct LikeEmptyView: View {
    @ObservedObject var viewStore: ViewStoreOf<LikeFeature>
    @ObservedObject var parentViewStore: ViewStoreOf<RootFeature>
    
    var body: some View {
        VStack {
            Spacer()
            if viewStore.isAuthed {
                EmptyView(type: .like)
            } else {
                EmptyView(type: .likeUnAuth) {
//                    viewStore.send(.emailLoginButtonTapped)
                    parentViewStore.send(.setNavigationRoot(.emailLogin))
                }
            }
            Spacer()
        }
    }
}
