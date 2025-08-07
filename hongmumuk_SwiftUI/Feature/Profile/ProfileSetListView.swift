//
//  ProfileSetListView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 3/6/25.
//

import SwiftUI

import ComposableArchitecture

struct ProfileSetListView: View {
    @ObservedObject var viewStore: ViewStoreOf<ProfileFeature>
    @ObservedObject var parentViewStore: ViewStoreOf<RootFeature>
    
    var body: some View {
        VStack(spacing: 0) {
            ProfileSetView(viewStore: viewStore, parentViewStore: parentViewStore, type: .info)
            ProfileSetView(viewStore: viewStore, parentViewStore: parentViewStore, type: .myReviews)
            ProfileSetView(viewStore: viewStore, parentViewStore: parentViewStore, type: .service)
            ProfileSetView(viewStore: viewStore, parentViewStore: parentViewStore, type: .privacy)
            ProfileSetView(viewStore: viewStore, parentViewStore: parentViewStore, type: .lang)
            ProfileSetView(viewStore: viewStore, parentViewStore: parentViewStore, type: .version)
        }
        .padding(.top, 24)
    }
}
