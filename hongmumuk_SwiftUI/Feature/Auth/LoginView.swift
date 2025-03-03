//
//  LoginView.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 2/13/25.
//

import ComposableArchitecture
import SwiftUI

struct LoginView: View {
    let store: StoreOf<LoginFeature>
    let parentStore: StoreOf<LoginInitialFeature>
    
    @ObservedObject var viewStore: ViewStoreOf<LoginFeature>
    @ObservedObject var parentViewStore: ViewStoreOf<LoginInitialFeature>
    
    init(store: StoreOf<LoginFeature>, parentStore: StoreOf<LoginInitialFeature>) {
        self.store = store
        self.parentStore = parentStore
        viewStore = ViewStore(store, observe: { $0 })
        parentViewStore = ViewStore(parentStore, observe: { $0 })
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Image("Logo_Blue")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width * 0.23)
                    .padding(.top, geometry.size.height * 0.28)
                    
                Spacer()
                    
                LoginButton(
                    title: "이메일로 로그인하기",
                    iconName: "LoginEmailIcon",
                    backgroundColor: Colors.Primary.normal,
                    textColor: .white,
                    action: {
                        viewStore.send(.signInButtonTapped)
                        parentStore.send(.signInButtonTapped)
                    }
                )
                .frame(height: 60)
                .padding(.horizontal, 24)
                .padding(.bottom, 12)
                    
                LoginButton(
                    title: "회원가입",
                    iconName: "SignupIcon",
                    backgroundColor: Color(hex: "FBFBFE"),
                    textColor: Colors.GrayScale.normal,
                    action: {
                        viewStore.send(.signUpButtonTapped)
                        parentStore.send(.signUpButtonTapped)
                    }
                )
                .frame(height: 60)
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
                    
                Button(action: {
                    viewStore.send(.signInGuest)
                    parentStore.send(.mainButtonTapped)
                }, label: {
                    Text("비회원으로 시작하기")
                        .fontStyle(Fonts.body1Medium)
                        .foregroundColor(Colors.GrayScale.alternative)
                })
                .padding(.bottom, geometry.size.height * 0.1)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
