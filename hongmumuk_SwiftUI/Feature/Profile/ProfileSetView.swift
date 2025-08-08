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
            if !viewStore.isUser, type == .info || type == .myReviews {
                viewStore.send(.loginButtonTapped)
            } else if type == .lang {
                viewStore.send(.langButtonTapped)
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
            right
        }
        .padding(.horizontal, 24)
    }
    
    private var text: some View {
        Text(type.title)
            .foregroundColor(Colors.GrayScale.grayscale95)
            .fontStyle(Fonts.heading1SemiBold)
    }
    
    private var right: some View {
        HStack(spacing: 4) {
            if type.showLoingText(viewStore.isUser) { loginText }
            if type == .version { versionText }
            if type == .lang { langText }
            
            if type.isShowArrow {
                Image("arrowIcon")
                    .resizable()
                    .frame(width: 20, height: 20)
            }
        }
    }
    
    private var loginText: some View {
        Text("login_required".localized())
            .foregroundColor(Colors.GrayScale.grayscale55)
            .fontStyle(Fonts.body1Medium)
    }
    
    private var versionText: some View {
        Text(viewStore.currentVersion)
            .foregroundColor(Colors.GrayScale.grayscale55)
            .fontStyle(Fonts.body1Medium)
    }
    
    private var langText: some View {
        Text(viewStore.currentLang)
            .foregroundColor(Colors.GrayScale.grayscale55)
            .fontStyle(Fonts.body1Medium)
    }
}
