//
//  ProfileSetView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 3/6/25.
//

import SwiftUI

import ComposableArchitecture

struct ProfileSetView: View {
    @ObservedObject var viewStore: ViewStoreOf<ProfileFeature>
    @ObservedObject var parentViewStore: ViewStoreOf<RootFeature>
    private let type: ProfileSet
    
    init(
        viewStore: ViewStoreOf<ProfileFeature>,
        parentViewStore: ViewStoreOf<RootFeature>,
        type: ProfileSet
    ) {
        self.viewStore = viewStore
        self.parentViewStore = parentViewStore
        self.type = type
    }
    
    var body: some View {
        VStack {
            if type.isButton {
                contentsButton
            } else {
                contents
            }
        }
        .frame(height: 60)
    }
    
    private var contentsButton: some View {
        Button(action: {
            if !viewStore.isUser, type == .info {
                viewStore.send(.loginButtonTapped)
            } else {
                parentViewStore.send(.profileButtonTapped(type))
            }
        }) {
            contents
        }
    }
    
    private var contents: some View {
        HStack(spacing: 0) {
            text
            Spacer()
            if type.showLoingText(viewStore.isUser) { loginText }
            if type == .version { versionText }
        }
        .padding(.horizontal, 24)
    }
    
    private var text: some View {
        Text(type.title)
            .foregroundColor(Colors.GrayScale.grayscale95)
            .fontStyle(Fonts.heading1SemiBold)
    }
    
    private var loginText: some View {
        Text("로그인이 필요합니다")
            .foregroundColor(Colors.GrayScale.grayscale55)
            .fontStyle(Fonts.body1Medium)
    }
    
    private var versionText: some View {
        Text(viewStore.currentVersion)
            .foregroundColor(Colors.GrayScale.grayscale55)
            .fontStyle(Fonts.body1Medium)
    }
}
