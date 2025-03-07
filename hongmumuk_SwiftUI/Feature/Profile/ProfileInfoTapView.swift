//
//  ProfileInfoTapView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 3/7/25.
//

import SwiftUI

import ComposableArchitecture

struct ProfileInfoTapView: View {
    @ObservedObject var viewStore: ViewStoreOf<ProfileInfoFeature>
    
    var body: some View {
        TabView(selection: viewStore.binding(
            get: { $0.pickerSelection },
            send: ProfileInfoFeature.Action.pickerSelectionChanged
        )) {
//            DetailMapView(viewStore: viewStore)
//                .tag(0)
//
//            DetailReviewView(viewStore: viewStore)
//                .tag(1)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
}
