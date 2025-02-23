//
//  EmailLoginFeature.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/10/25.
//

import ComposableArchitecture
import Foundation
import SwiftUI

struct EmailLoginFeature: Reducer {
    enum ActiveScreen {
        case none, main, findPassword, signUp
    }
    
    struct State: Equatable {
        var email: String = ""
        var emailFocused: Bool = false
        var emailValid: Bool = false
        var emailErrorMessage: String? = nil
        
        var emailBackgroundColor: Color = .init(hex: "FAFBFE")
        var emailBorderColor: Color = Colors.Border.strong
        var emailTextColor: Color = Colors.GrayScale.normal
        
        var password: String = ""
        var passwordFocused: Bool = false
        var passwordValid: Bool = false
        var passwordVisible: Bool = false
        var passwordErrorMessage: String? = nil
        
        var passwordBackgroundColor: Color = .init(hex: "FAFBFE")
        var passwordBorderColor: Color = Colors.Border.strong
        var passwordTextColor: Color = Colors.GrayScale.normal
        
        var isLoginLoading: Bool = false
        var activeScreen: ActiveScreen = .none
        
        var isSigninEnabled: Bool {
            emailValid && passwordValid
        }
    }
    
    enum Action: Equatable {
        case emailChanged(String)
        case passwordChanged(String)
        
        case emailFocused(Bool)
        case passwordFocused(Bool)
        
        case emailOnSubmit
        case passwordOnSubmit
        
        case emailTextClear
        case passwordTextClear
        
        case updateEmailTextField
        case updatePasswordTextField
        
        case passwordVisibleToggled
        
        case signInButtonTapped
        case findPasswordButtonTapped, signUpButtonTapped, backButtonTapped
        case successLogin, failLogin(LoginError)
        case onDismiss
    }
    
    @Dependency(\.validationClient) var validationClient
    @Dependency(\.authClient) var authClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .emailChanged(email):
                state.email = email
                return .send(.updateEmailTextField)
            
            case let .passwordChanged(password):
                state.password = password
                return .send(.updatePasswordTextField)
                
            case let .emailFocused(isFocused):
                state.emailFocused = isFocused
                state.emailErrorMessage = nil
                return .send(.updateEmailTextField)
            
            case let .passwordFocused(isFocused):
                state.passwordFocused = isFocused
                state.passwordErrorMessage = nil
                return .send(.updatePasswordTextField)
                
            case .emailOnSubmit:
                let isValid = validationClient.validateEmail(state.email)
                state.emailFocused = false
                state.emailValid = isValid
                return .send(.updateEmailTextField)
            
            case .passwordOnSubmit:
                let isValid = validationClient.validatePassword(state.password)
                state.passwordFocused = false
                state.passwordValid = isValid
                return .send(.updatePasswordTextField)
            
            case .emailTextClear:
                state.email = ""
                return .none
            
            case .passwordTextClear:
                state.password = ""
                return .none
                
            case .updateEmailTextField:
                if state.emailFocused {
                    state.emailBackgroundColor = Color(hex: "FBFBFE")
                    state.emailBorderColor = Colors.Primary.normal
                    state.emailTextColor = Colors.GrayScale.normal
                    state.emailErrorMessage = nil
                    return .none
                }
                
                if state.email.isEmpty {
                    state.emailBackgroundColor = Color(hex: "FBFBFE")
                    state.emailBorderColor = Colors.Border.strong
                    state.emailTextColor = Colors.GrayScale.normal
                    state.emailErrorMessage = nil
                    return .none
                }

                if !state.emailValid {
                    state.emailBackgroundColor = Color(hex: "FFE8E5")
                    state.emailBorderColor = Colors.SemanticColor.negative
                    state.emailTextColor = Colors.SemanticColor.negative
                    state.emailErrorMessage = "올바르지 않은 이메일 형식입니다."
                } else {
                    state.emailBackgroundColor = Color(hex: "FBFBFE")
                    state.emailBorderColor = Colors.Border.strong
                    state.emailTextColor = Colors.GrayScale.normal
                    state.emailErrorMessage = nil
                }
                return .none
            
            case .updatePasswordTextField:
                if state.passwordFocused {
                    state.passwordBackgroundColor = Color(hex: "FBFBFE")
                    state.passwordBorderColor = Colors.Primary.normal
                    state.passwordTextColor = Colors.GrayScale.normal
                    state.passwordErrorMessage = nil
                    return .none
                }
                
                if state.password.isEmpty {
                    state.passwordBackgroundColor = Color(hex: "FBFBFE")
                    state.passwordBorderColor = Colors.Primary.normal
                    state.passwordTextColor = Colors.GrayScale.normal
                    state.passwordErrorMessage = nil
                    return .none
                }

                if !state.passwordValid {
                    state.passwordBackgroundColor = Color(hex: "FFE8E5")
                    state.passwordBorderColor = Colors.SemanticColor.negative
                    state.passwordTextColor = Colors.SemanticColor.negative
                    state.passwordErrorMessage = "올바르지 않은 비밀번호 형식입니다."
                } else {
                    state.passwordBackgroundColor = Color(hex: "FBFBFE")
                    state.passwordBorderColor = Colors.Border.strong
                    state.passwordTextColor = Colors.GrayScale.normal
                    state.passwordErrorMessage = nil
                }
                return .none
                
            case .passwordVisibleToggled:
                state.passwordVisible.toggle()
                return .none
                
            case .signInButtonTapped:
    
                return handleLogin(state.email, state.password)
                
            case .signUpButtonTapped:
                state.activeScreen = .signUp
                return .none
                
            case .findPasswordButtonTapped:
                state.activeScreen = .findPassword
                return .none
                
            case .backButtonTapped, .onDismiss:
                state.activeScreen = .none
                return .none
                
            case .successLogin:
                state.activeScreen = .main
                return .none
                
            case let .failLogin(error):
                handleLoginError(error)
                return .none
            }
        }
    }
    
    private func handleLogin(_ email: String, _ password: String) -> Effect<Action> {
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
    }
    
    private func handleLoginError(_ error: LoginError) {
        switch error {
        case .invalid:
            print("invalid login")
        case .unKnown:
            print("unknown error")
        }
    }
}
