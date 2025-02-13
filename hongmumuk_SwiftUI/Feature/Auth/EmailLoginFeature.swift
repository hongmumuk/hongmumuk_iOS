//
//  EmailLoginFeature.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/10/25.
//

import ComposableArchitecture
import Foundation

struct EmailLoginFeature: Reducer {
    enum ActiveScreen {
        case none
        case main
        case findPassword
        case signUp
    }
    
    struct State: Equatable {
        var email: String = ""
        var password: String = ""
        var isEnabledSingInButton = false
        var emailTextFiledState: TextFiledState = .none
        var passwordTextFiledState: TextFiledState = .none
        var isVisiblePassword: Bool = false
        var pop: Bool = false
        var activeScreen: ActiveScreen = .none
    }
    
    enum Action: Equatable {
        case emailChanged(String)
        case passwordChanged(String)
        case emailOnSubmit(String)
        case passwordOnSubmit(String)
        case emailOnFocused
        case passwordOnFocused
        case signInButtonTapped(email: String, password: String)
        case signUpButtonTapped
        case findPaasswordButtonTapped
        case backButtonTapped
        case togglePasswordVisibility(Bool)
        case successLogin
        case failLogin(LoginError)
        case onDismiss
    }
    
    @Dependency(\.validationClient) var validationClient
    @Dependency(\.authClient) var authClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .emailChanged(email):
                state.email = email
                return .none
            case let .passwordChanged(password):
                state.password = password
                return .none
            case let .emailOnSubmit(email):
                let errorMessage = "올바르지 않은 이메일 형식입니다"
                let isValid = validationClient.validateEmail(email)
                state.emailTextFiledState = isValid ? .valid : .invalid(errorMessage)
                state.isEnabledSingInButton = state.emailTextFiledState == .valid && state.passwordTextFiledState == .valid
                return .none
            case let .passwordOnSubmit(password):
                let errorMessage = "올바르지 않은 비밀번호 형식입니다"
                let isValid = validationClient.validatePassword(password)
                state.passwordTextFiledState = isValid ? .valid : .invalid(errorMessage)
                state.isEnabledSingInButton = state.emailTextFiledState == .valid && state.passwordTextFiledState == .valid
                return .none
            case .emailOnFocused:
                state.emailTextFiledState = .focused
                return .none
            case .passwordOnFocused:
                state.passwordTextFiledState = .focused
                return .none
            case let .signInButtonTapped(email, password):
                let body = LoginModel(email: email, password: password)
                return .run { send in
                    do {
                        if try await authClient.login(body) {
                            await send(.successLogin)
                        }
                    } catch {
                        if let loginError = error as? LoginError {
                            await send(.failLogin(loginError))
                        }
                    }
                }
            case .signUpButtonTapped:
                state.activeScreen = .signUp
                return .none
            case .onDismiss:
                state.activeScreen = .none
                return .none
            case .findPaasswordButtonTapped:
                state.activeScreen = .findPassword
                return .none
            case .backButtonTapped:
                state.pop = true
                return .none
            case let .togglePasswordVisibility(isVisible):
                state.isVisiblePassword = isVisible
                return .none
            case .successLogin:
                state.activeScreen = .main
                return .none
            case let .failLogin(error):
                // 아직 구체적이 에러 처리 기획이 안 되어 있는 상태
                // 아마 얼럿이나 이런걸로 대체하지 않을까?
                switch error {
                case .invalid:
                    print("invalid")
                case .unKnown:
                    print("unKnown")
                }
                return .none
            }
        }
    }
}
