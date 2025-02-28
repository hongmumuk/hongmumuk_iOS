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
        //        var emailFocused: Bool = false
        //        var emailValid: Bool = false
        var emailErrorMessage: String? = nil
        var emailState: TextFieldState = .empty
        
        var password: String = ""
        //        var passwordFocused: Bool = false
        //        var passwordValid: Bool = false
        var passwordVisible: Bool = false
        var passwordErrorMessage: String? = nil
        var passwordState: TextFieldState = .empty
        
        var loginError: LoginError? = nil
        
        var isLoginLoading: Bool = false
        var activeScreen: ActiveScreen = .none
        
        var isSigninEnabled: Bool {
            return !isLoginLoading && loginError == nil && emailState == .valid && passwordState == .valid
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
                return .none
                
            case let .passwordChanged(password):
                state.password = password
                return .none
                
            case let .emailFocused(isFocused):
                state.emailState = isFocused ? .focused : (state.email.isEmpty ? .empty : .normal)
                state.emailErrorMessage = nil
                if state.loginError != nil {
                    state.loginError = nil
                    state.passwordState = .normal
                    state.passwordErrorMessage = nil
                }
                return .none
                
            case let .passwordFocused(isFocused):
                state.passwordState = isFocused ? .focused : (state.password.isEmpty ? .empty : .normal)
                state.emailErrorMessage = nil
                if state.loginError != nil {
                    state.loginError = nil
                    state.emailState = .normal
                    state.emailErrorMessage = nil
                }
                return .none
                
            case .emailOnSubmit:
                if state.email.isEmpty {
                    state.emailState = .empty
                    state.emailErrorMessage = nil
                } else if !validationClient.validateEmail(state.email) {
                    state.emailState = .invalid
                    state.emailErrorMessage = "이메일 형식이 잘못되었습니다."
                } else {
                    state.emailState = .valid
                    state.emailErrorMessage = nil
                }
                return .none
                
            case .passwordOnSubmit:
                if state.password.isEmpty {
                    state.passwordState = .empty
                    state.passwordErrorMessage = nil
                } else if !validationClient.validatePassword(state.password) {
                    state.passwordState = .invalid
                    state.passwordErrorMessage = "비밀번호 형식이 잘못되었습니다."
                } else {
                    state.passwordState = .valid
                    state.passwordErrorMessage = nil
                }
                return .none
                
            case .emailTextClear:
                state.email = ""
                state.emailState = .empty
                state.emailErrorMessage = nil
                return .none
                
            case .passwordTextClear:
                state.password = ""
                state.passwordState = .empty
                state.passwordErrorMessage = nil
                return .none
                
            case .passwordVisibleToggled:
                state.passwordVisible.toggle()
                return .none
                
            case .signInButtonTapped:
                state.isLoginLoading = true
                let newEmail = "\(state.email)@g.hongik.ac.kr"
                let body = LoginModel(email: newEmail, password: state.password)
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
                
            case .findPasswordButtonTapped:
                state.activeScreen = .findPassword
                return .none
                
            case .backButtonTapped, .onDismiss:
                state.activeScreen = .none
                return .none
                
            case .successLogin:
                state.isLoginLoading = false
                state.activeScreen = .main
                return .none
                
            case let .failLogin(error):
                state.isLoginLoading = false
                state.loginError = error
                if state.loginError != nil {
                    state.emailState = .loginError
                    state.passwordState = .loginError
                }
                state.emailErrorMessage = error == .unKnown ? "가입된 계정이 없습니다. 이메일을 다시 확인해주세요." : nil
                state.passwordErrorMessage = error == .invalid ? "비밀번호가 올바르지 않습니다." : nil
                return .none
            }
        }
    }
}
