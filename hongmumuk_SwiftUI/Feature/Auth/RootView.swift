//
//  RootView.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 3/4/25.
//

import ComposableArchitecture
import SwiftUI

struct RootView: View {
    let store: StoreOf<RootFeature>
    @ObservedObject var viewStore: ViewStoreOf<RootFeature>
    
    init(store: StoreOf<RootFeature>) {
        self.store = store
        viewStore = ViewStore(store, observe: { $0 })
    }
    
    // 자식 피쳐에서 자세한 스테이트 관찰이 필요할 때 -> Scope
    // 단순 네비게이션 -> Store에서 ParentStore 받기
    var body: some View {
        NavigationStack(path: viewStore.binding(
            get: \.navigationPath,
            send: { RootFeature.Action.setNavigationPath($0) }
        )) {
            Group {
                if viewStore.isLoggedIn {
                    HomeRootView(parentStore: store)
                        .navigationBarHidden(true)
                } else if viewStore.isLoading {
                    SplashView()
                } else {
                    LoginView(store: Store(initialState: LoginFeature.State(), reducer: LoginFeature.init), parentStore: store)
                }
            }
            .navigationDestination(for: RootFeature.ActiveScreen.self) { screen in
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
                        store: store
                            .scope(
                                state: \.emailLogin,
                                action: RootFeature.Action.emailLogin
                            ),
                        parentStore: store
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
                        store: store
                            .scope(
                                state: \.signupPassword,
                                action: RootFeature.Action.signupPassword
                            ),
                        parentStore: store
                    )
                    .navigationBarHidden(true)
                case .signupDone:
                    SignupDoneView(parentStore: store)
                        .navigationBarHidden(true)
                case .home:
                    HomeRootView(parentStore: store)
                        .navigationBarHidden(true)
                case .random:
                    RandomView(store: Store(initialState: RandomFeature.State(), reducer: RandomFeature.init))
                        .navigationBarHidden(true)
                case .verifyEmail:
                    VerifyEmailView(store: Store(initialState: VerifyEmailFeature.State(), reducer: VerifyEmailFeature.init), parentStore: store)
                        .navigationBarHidden(true)
                case .resetPassword:
                    ResetPasswordView(
                        store: store
                            .scope(
                                state: \.resetPassword,
                                action: RootFeature.Action.resetPassword
                            ), parentStore: store
                    )
                    .navigationBarHidden(true)
                case let .categoryList(category):
                    CategoryView(
                        store: Store(
                            initialState: CategoryFeature.State(
                                cateogry: category
                            ),
                            reducer: { CategoryFeature() },
                            withDependencies: {
                                $0.restaurantClient = RestaurantClient.liveValue
                            }
                        ),
                        parentStore: store
                    )
                    .navigationBarHidden(true)
                case .search:
                    SearchView(
                        store: Store(
                            initialState: SearchFeature.State(),
                            reducer: { SearchFeature() },
                            withDependencies: {
                                $0.restaurantClient = RestaurantClient.liveValue
                                $0.userDefaultsClient = UserDefaultsClient.liveValue
                            }
                        )
                    )
                    .navigationBarHidden(true)
                case let .profile(type):
                    if type == .info {
                        ProfileInfoView(
                            store: Store(
                                initialState: ProfileInfoFeature.State(),
                                reducer: { ProfileInfoFeature() }
                            ),
                            parentStore: store
                        )
                        .navigationBarHidden(true)
                        
                    } else {
                        WebView(
                            title: type.title,
                            urlString: type.urlString,
                            parentStore: store
                        )
                        .navigationBarHidden(true)
                    }
                case .inqury:
                    let urlString = "https://forms.gle/e8X1RPPJCDWkwj5JA"
                    WebView(
                        title: "문의하기",
                        urlString: urlString,
                        parentStore: store
                    )
                    .navigationBarHidden(true)
                default:
                    Text("Error")
                }
            }
        }
        .onAppear {
            viewStore.send(.checkLoginStatus)
        }
    }
}

//    .navigationDestination(
//        isPresented: viewStore.binding(
//            get: { $0.activeScreen != .none && $0.activeScreen != .random },
//            send: .onDismiss
//        )
//    ) {
//        let screen = viewStore.activeScreen
//        if case .search = screen {
//            SearchView(
//                store: Store(
//                    initialState: SearchFeature.State(),
//                    reducer: { SearchFeature() },
//                    withDependencies: {
//                        $0.restaurantClient = RestaurantClient.liveValue
//                        $0.userDefaultsClient = UserDefaultsClient.liveValue
//                    }
//                )
//            )
//            .navigationBarHidden(true)
//
//        } else if case let .cateogryList(category) = screen {
//            CategoryView(
//                store: Store(
//                    initialState: CategoryFeature.State(
//                        cateogry: category
//                    ),
//                    reducer: { CategoryFeature() },
//                    withDependencies: {
//                        $0.restaurantClient = RestaurantClient.liveValue
//                    }
//                )
//            )
//            .navigationBarHidden(true)
//        }
