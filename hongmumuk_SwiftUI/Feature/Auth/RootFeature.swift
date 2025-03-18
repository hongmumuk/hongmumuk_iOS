//
//  RootFeature.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 3/4/25.
//

import ComposableArchitecture
import SwiftUI

struct RootFeature: Reducer {
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
    }
    
    struct State: Equatable {
        var navigationPath: [ActiveScreen] = []
        var emailLogin = EmailLoginFeature.State()
        var signupPassword = SignupPasswordFeature.State()
        var resetPassword = ResetPasswordFeature.State()
        
        var isLoggedIn: Bool = false
        var isLoading: Bool = true
        var isFirstLaunch: Bool = true
    }
    
    enum Action: Equatable {
        case navigationTo(ActiveScreen)
        case setNavigationRoot(ActiveScreen)
        case onDismiss
        case setNavigationPath([ActiveScreen])
        case emailLogin(EmailLoginFeature.Action)
        case signupPassword(SignupPasswordFeature.Action)
        case resetPassword(ResetPasswordFeature.Action)
        case resetAllFeatureStates
        
        case resetStackAndLoadHome
        
        case checkLoginStatus
        case setLoginStatus(Bool)
        case setLoadingStatus(Bool)
        case setFirstLaunch(Bool)
        
        case profileButtonTapped(ProfileSet)
        case inquryButtonTapped
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
                
            case .checkLoginStatus:
                return .run { send in
                    await send(.setLoadingStatus(true))

                    let isFirstLaunch = await !(userDefaultsClient.getBool(.isNotFirstLaunch))
                    if isFirstLaunch {
                        await keychainClient.remove(.accessToken)
                        await keychainClient.remove(.refreshToken)
                        await userDefaultsClient.setBool(true, .isNotFirstLaunch)
                        await send(.setFirstLaunch(true))
                        await send(.setLoginStatus(false))
                        await send(.setLoadingStatus(false))
                        return
                    }

                    await send(.setFirstLaunch(false))

                    let accessToken = await keychainClient.getString(.accessToken)
                    let refreshToken = await keychainClient.getString(.refreshToken)

                    if let accessToken, !accessToken.isEmpty, isValidAccessToken(accessToken) {
                        await send(.setLoginStatus(true))
                    } else if let refreshToken, !refreshToken.isEmpty {
                        do {
                            let newTokens: AuthTokenResponseModel = try await authClient.token(accessToken!, refreshToken)
                            await keychainClient.setString(newTokens.accessToken, .accessToken)
                            await keychainClient.setString(newTokens.refreshToken, .refreshToken)
                            await send(.setLoginStatus(true))
                        } catch {
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
    
    // TODO: - 토큰 에러 확인..
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
