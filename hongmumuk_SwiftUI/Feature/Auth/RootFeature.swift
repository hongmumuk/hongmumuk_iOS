//
//  RootFeature.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 3/4/25.
//

import Combine
import SwiftUI

import ComposableArchitecture

struct RootFeature: Reducer {
    @StateObject private var networkManager = NetworkManager.shared
    
    enum ActiveScreen: Equatable, Hashable {
        case splash
        case onboarding
        case login
        case emailLogin
        case signup
        case signupEmail
        case signupPassword
        case signupDone
        case verifyEmail
        case resetPassword
        case home
        case like
        case random
        case search
        case categoryList(Category)
        case profile(ProfileSet)
        case myReviews
    }
    
    struct State: Equatable {
        var navigationPath: [ActiveScreen] = []
        var emailLogin = EmailLoginFeature.State()
        var signupPassword = SignupPasswordFeature.State()
        var resetPassword = ResetPasswordFeature.State()
        
        var isLoggedIn: Bool = false
        var isLoading: Bool = true
        var isFirstLaunch: Bool = true
    
        var showVersionAlert: Bool = false
        var showNetworkError: Bool = false
        var isBlockedByVersion: Bool {
            showVersionAlert
        }
    }
    
    enum Action: Equatable {
        case navigationTo(ActiveScreen)
        case setNavigationRoot(ActiveScreen)
        case onAppear
        case onDismiss
        case setNavigationPath([ActiveScreen])
        case emailLogin(EmailLoginFeature.Action)
        case signupPassword(SignupPasswordFeature.Action)
        case resetPassword(ResetPasswordFeature.Action)
        case resetAllFeatureStates
        case logout
        case onboardingCompleted
        
        case resetStackAndLoadHome
        
        case checkLoginStatus
        case checkVersion
        case forceUpdateTapped
        case setLoginStatus(Bool)
        case setLoadingStatus(Bool)
        case setFirstLaunch(Bool)
        
        case profileButtonTapped(ProfileSet)
        case inquryButtonTapped
        
        case setShowNetworkError(Bool)
        case setShowVersionAlert(Bool)
    }
    
    @Dependency(\.keychainClient) var keychainClient
    @Dependency(\.authClient) var authClient
    @Dependency(\.userDefaultsClient) var userDefaultsClient
    
    var body: some ReducerOf<Self> {
        Scope(state: \State.emailLogin, action: /Action.emailLogin) {
            EmailLoginFeature()
        }
        Scope(state: \State.signupPassword, action: /Action.signupPassword) {
            SignupPasswordFeature()
        }
        Scope(state: \State.resetPassword, action: /Action.resetPassword) {
            ResetPasswordFeature()
        }
        
        Reduce { state, action in
            switch action {
            case let .navigationTo(screen):
                state.navigationPath.append(screen)
                return .none
                
            case let .setNavigationPath(path):
                state.navigationPath = path
                return .none
                
            case let .setNavigationRoot(path):
                state.navigationPath = [path]
                return .none
                
            case .onAppear:
                return .merge(
                    // 버전 체크
                    .run { send in
                        await send(.checkVersion)
                    },
                    // 로그아웃 알림 수신
                    .run { send in
                        for await _ in NotificationCenter.default.notifications(named: .shouldLogout) {
                            await send(.logout)
                        }
                    },
                    
                    // 네트워크 끊김 감지
                    .run { send in
                        let stream = AsyncStream<Bool> { continuation in
                            let cancellable = NetworkManager.shared.$isConnected
                                .filter { !$0 }
                                .sink { isConnected in
                                    continuation.yield(isConnected)
                                }
                            
                            continuation.onTermination = { _ in
                                cancellable.cancel()
                            }
                        }
                        
                        for await isConnected in stream {
                            await send(.setShowNetworkError(!isConnected))
                        }
                    }
                )
                
            case let .setShowNetworkError(isShow):
                if isShow {
                    state.showNetworkError = true
                }
                
                return .none
                
            case let .setShowVersionAlert(show):
                state.showVersionAlert = show
                return .none

            case .forceUpdateTapped:
                if let url = URL(string: "https://apps.apple.com/app/id6464114749") {
                    UIApplication.shared.open(url)
                }
                return .none
                
            case .checkVersion:
                return .run { send in
                    let currentVersion = Bundle.main.fullVersion
                    let minimumVersion = "2.0.3"
                    
                    print(currentVersion)
                    
                    if compareVersion(currentVersion, minimumVersion) == .orderedAscending {
                        await send(.setShowVersionAlert(true))
                    }
                }
                
            case .onDismiss:
                state.navigationPath.removeLast()
                return .none
                
            // emailLoginFeature
            case .emailLogin(.successLogin):
                return .concatenate(
                    .send(.resetAllFeatureStates),
                    .send(.setNavigationPath([.home])),
                    .send(.resetStackAndLoadHome)
                )
                
            case .resetStackAndLoadHome:
                state.isLoggedIn = true
                return .none
                
            // signupPasswordFeature
            case .signupPassword(.successJoin):
                return .concatenate(
                    .send(.resetAllFeatureStates),
                    .send(.navigationTo(.signupDone))
                )
                
            // resetPasswordFeature
            case .resetPassword(.successReset):
                return .concatenate(
                    .send(.resetAllFeatureStates),
                    .send(.setNavigationRoot(.login))
                )
                
            case .resetAllFeatureStates:
                state.emailLogin = EmailLoginFeature.State()
                state.signupPassword = SignupPasswordFeature.State()
                state.resetPassword = ResetPasswordFeature.State()
                return .none
                
            // onboarding
            case .onboardingCompleted:
                state.isFirstLaunch = false
                return .run { _ in
                    await userDefaultsClient.setBool(true, .isNotFirstLaunch)
                }
                
            case .logout:
                state.isLoggedIn = false
                state.navigationPath = [.login]
                return .run { _ in
                    await keychainClient.remove(.accessToken)
                    await keychainClient.remove(.refreshToken)
                }
                
            case .checkLoginStatus:
                return .run { send in
                    await send(.setLoadingStatus(true))
                    
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                    
                    let isNotFirstLaunch = await userDefaultsClient.getBool(.isNotFirstLaunch) ?? false
                    let isFirstLaunch = !isNotFirstLaunch
                    await send(.setFirstLaunch(isFirstLaunch))
                    
                    // 앱 첫 실행
                    if isFirstLaunch {
                        await keychainClient.remove(.accessToken)
                        await keychainClient.remove(.refreshToken)
                        await send(.setLoginStatus(false))
                        await send(.setLoadingStatus(false))
                        return
                    }
                    
                    // 앱 첫 실행 아닐 경우
                    let accessToken = await keychainClient.getString(.accessToken)
                    let refreshToken = await keychainClient.getString(.refreshToken)
                    
                    if let accessToken, !accessToken.isEmpty {
                        if isValidAccessToken(accessToken) {
                            await send(.setLoginStatus(true))
                        } else if let refreshToken, !refreshToken.isEmpty {
                            do {
                                let newToken = try await authClient.token(accessToken, refreshToken)
                                
                                await keychainClient.setString(newToken.accessToken, .accessToken)
                                await keychainClient.setString(newToken.refreshToken, .refreshToken)
                                await send(.setLoginStatus(true))
                            } catch {
                                await keychainClient.remove(.accessToken)
                                await keychainClient.remove(.refreshToken)
                                await send(.setLoginStatus(false))
                            }
                        } else {
                            await send(.setLoginStatus(false))
                        }
                    } else {
                        await send(.setLoginStatus(false))
                    }
                    
                    await send(.setLoadingStatus(false))
                }
                
            case let .setLoginStatus(isLoggedIn):
                state.isLoggedIn = isLoggedIn
                return .none
                
            case let .setLoadingStatus(isLoading):
                state.isLoading = isLoading
                return .none
                
            case let .setFirstLaunch(isFirstLaunch):
                state.isFirstLaunch = isFirstLaunch
                return .none
                
            case let .profileButtonTapped(type):
                state.navigationPath.append(.profile(type))
                return .none
                
            default:
                return .none
            }
        }
    }
    
    // 토큰 만료 앱 진입시 확인
    func isValidAccessToken(_ token: String) -> Bool {
        let components = token.components(separatedBy: ".")
        guard components.count == 3 else {
            return false
        }
        
        do {
            let base64Decoded = components[1]
                .replacingOccurrences(of: "-", with: "+")
                .replacingOccurrences(of: "_", with: "/")
            
            let paddedBase64 = base64Decoded.padding(toLength: ((base64Decoded.count + 3) / 4) * 4, withPad: "=", startingAt: 0)
            
            guard let jsonData = Data(base64Encoded: paddedBase64),
                  let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
                  let expiration = json["exp"] as? TimeInterval
            else {
                return false
            }
            
            return Date().timeIntervalSince1970 < expiration
        } catch {
            return false
        }
    }
    
    // versicon compaer
    func compareVersion(_ v1: String, _ v2: String) -> ComparisonResult {
        return v1.compare(v2, options: .numeric)
    }
}

// 스와이프 제스쳐
// extension UINavigationController: @retroactive ObservableObject, @retroactive UIGestureRecognizerDelegate {
//    override open func viewDidLoad() {
//        super.viewDidLoad()
//        interactivePopGestureRecognizer?.delegate = self
//    }
//
//    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        return viewControllers.count > 1
//    }
// }
