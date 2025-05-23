//
//  LoginView.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 3/5/25.
//

import ComposableArchitecture
import SwiftUI

struct LoginView: View {
    let store: StoreOf<LoginFeature>
    let parentStore: StoreOf<RootFeature>
    
    @ObservedObject var viewStore: ViewStoreOf<LoginFeature>
    @ObservedObject var parentViewStore: ViewStoreOf<RootFeature>
    
    init(store: StoreOf<LoginFeature>, parentStore: StoreOf<RootFeature>) {
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
                    title: "login_with_email".localized(),
                    iconName: "LoginEmailIcon",
                    backgroundColor: Colors.Primary.normal,
                    textColor: .white,
                    action: {
                        viewStore.send(.signInButtonTapped)
                        parentStore.send(.navigationTo(.emailLogin))
                    }
                )
                .frame(height: 60)
                .padding(.horizontal, 24)
                .padding(.bottom, 12)
                    
                LoginButton(
                    title: "sign_up".localized(),
                    iconName: "SignupIcon",
                    backgroundColor: Color(hex: "FBFBFE"),
                    textColor: Colors.GrayScale.normal,
                    action: {
                        viewStore.send(.signUpButtonTapped)
                        parentStore.send(.navigationTo(.signup))
                    }
                )
                .frame(height: 60)
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
                    
                Button(action: {
                    viewStore.send(.signInGuest)
                    parentStore.send(.setNavigationRoot(.home))
                }, label: {
                    Text("start_as_guest".localized())
                        .fontStyle(Fonts.body1Medium)
                        .foregroundColor(Colors.GrayScale.alternative)
                })
                .padding(.bottom, geometry.size.height * 0.1)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
