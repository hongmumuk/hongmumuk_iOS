//
//  LoginInitialView.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 3/4/25.
//

import ComposableArchitecture
import SwiftUI

struct LoginInitialView: View {
    let store: StoreOf<LoginInitialFeature>
    @ObservedObject var viewStore: ViewStoreOf<LoginInitialFeature>
    
    init(store: StoreOf<LoginInitialFeature>) {
        self.store = store
        viewStore = ViewStore(store, observe: { $0 })
    }

    var body: some View {
        NavigationStack(path: viewStore.binding(
            get: \.navigationPath,
            send: { LoginInitialFeature.Action.setNavigationPath($0) }
        )) {
            LoginView(
                store: Store(
                    initialState: LoginFeature.State(),
                    reducer: LoginFeature.init
                ),
                parentStore: store
            )
            .navigationDestination(for: LoginInitialFeature.ActiveScreen.self) { screen in
                switch screen {
                case .login:
                    LoginView(
                        store: Store(
                            initialState: LoginFeature.State(),
                            reducer: LoginFeature.init
                        ),
                        parentStore: store
                    )
                    .navigationBarHidden(true)
                case .emailLogin:
                    EmailLoginView(
                        store: Store(
                            initialState: EmailLoginFeature.State(),
                            reducer: EmailLoginFeature.init
                        ), parentStore: store
                    )
                    .navigationBarHidden(true)
                case .signup:
                    PrivacyView(
                        store: Store(
                            initialState: PrivacyFeature.State(),
                            reducer: PrivacyFeature.init
                        ), parentStore: store
                    )
                    .navigationBarHidden(true)
                case .signupEmail:
                    SignupEmailView(
                        store: Store(
                            initialState: SignupEmailFeature.State(),
                            reducer: SignupEmailFeature.init
                        ),
                        parentStore: store
                    )
                    .navigationBarHidden(true)
                case .signupPassword:
                    SignupPasswordView(
                        store: Store(
                            initialState: SignupPasswordFeature.State(),
                            reducer: SignupPasswordFeature.init
                        ),
                        parentStore: store
                    )
                    .navigationBarHidden(true)
                case .signupDone:
                    SignupDoneView(parentStore: Store(initialState: LoginInitialFeature.State(), reducer: LoginInitialFeature.init))
                        .navigationBarHidden(true)
                case .main:
                    RootView()
                case .verifyEmail:
                    VerifyEmailView(store: Store(initialState: VerifyEmailFeature.State(), reducer: VerifyEmailFeature.init))
                        .navigationBarHidden(true)
                case .resetPassword:
                    ResetPasswordView(store: Store(initialState: ResetPasswordFeature.State(), reducer: ResetPasswordFeature.init))
                        .navigationBarHidden(true)
                }
            }
        }
    }
}
