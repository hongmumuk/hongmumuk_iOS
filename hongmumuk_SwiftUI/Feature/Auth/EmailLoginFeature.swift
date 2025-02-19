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
        case none, main, findPassword, signUp
    }
    
    enum FocusedField {
        case email, password, none
    }
    
    struct State: Equatable {
        var emailState = TextFieldState()
        var passwordState = TextFieldState()
        var focusedField: FocusedField? = nil
        var isPasswordVisible: Bool = false
        var isSubmitLoading: Bool = false
        var activeScreen: ActiveScreen = .none
        
        var isSigninEnabled: Bool {
            emailState.status == .valid && passwordState.status == .valid
        }
    }
    
    enum Action: Equatable {
        case emailChanged(String)
        case passwordChanged(String)
        case validateField(FocusedField)
        case focusField(FocusedField)
        case clearField(FocusedField)
        case togglePasswordVisibility
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
                updateFieldState(&state.emailState, text: email, isFocused: state.focusedField == .email)
                return .none
                
            case let .passwordChanged(password):
                updateFieldState(&state.passwordState, text: password, isFocused: state.focusedField == .password)
                return .none
                
            case let .validateField(field):
                validateField(&state, field: field)
                return .none
                
            case let .focusField(focusedField):
                state.focusedField = focusedField
                focusFieldState(&state, field: focusedField)
                return .none
                
            case let .clearField(field):
                if field == .email { state.emailState.text = "" }
                if field == .password { state.passwordState.text = "" }
                return .none
                
            case .togglePasswordVisibility:
                state.isPasswordVisible.toggle()
                if state.focusedField == .password {
                    return .send(.focusField(.password))
                }
                return .none
                
            case .signInButtonTapped:
                return handleLogin(state.emailState.text, state.passwordState.text)
                
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
    
    private func updateFieldState(_ fieldState: inout TextFieldState, text: String, isFocused: Bool) {
        fieldState.text = text
        fieldState.status = isFocused ? .focused : .default
    }
    
    private func validateField(_ state: inout State, field: FocusedField) {
        switch field {
        case .email:
            let isValid = validationClient.validateEmail(state.emailState.text)
            state.emailState.updateStatus(isFocused: false, isValid: isValid, message: isValid ? nil : "올바르지 않은 이메일 형식입니다")
            
        case .password:
            let isValid = validationClient.validatePassword(state.passwordState.text)
            state.passwordState.updateStatus(isFocused: false, isValid: isValid, message: isValid ? nil : "올바르지 않은 비밀번호 형식입니다")
            
        case .none:
            break
        }
    }
    
    private func focusFieldState(_ state: inout State, field: FocusedField) {
        switch field {
        case .email:
            state.emailState.updateStatus(isFocused: true, isValid: state.emailState.status == .valid)
        case .password:
            state.passwordState.updateStatus(isFocused: true, isValid: state.passwordState.status == .valid)
        case .none:
            state.emailState.updateStatus(isFocused: false, isValid: state.emailState.status == .valid)
            state.passwordState.updateStatus(isFocused: false, isValid: state.passwordState.status == .valid)
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
