//
//  ResetPasswordFeature.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 3/1/25.
//

import ComposableArchitecture
import SwiftUI

struct ResetPasswordFeature: Reducer {
    // ActiveScreen은 EmailLoginFeature에서 관리
    struct State: Equatable {
        var password: String = ""
        var passwordErrorMessage: String? = nil
        var passwordState: TextFieldState = .empty
        
        var verifiedPassword: String = ""
        var verifiedPasswordErrorMessage: String? = nil
        var verifiedPasswordState: TextFieldState = .empty
        
        var resetPasswordError: LoginError? = nil
        
        var isResetPasswordLoading: Bool = false
        
        var isResetPasswordButtonEnabled: Bool {
            // 여기서 밸리드는 같냐 안같냐로 결정
            passwordState == .valid && verifiedPasswordState == .valid
        }
    }
    
    enum Action: Equatable {
        case passwordChanged(String)
        case verifiedPasswordChanged(String)
        
        case passwordFocused(Bool)
        case verifiedPasswordFocused(Bool)
        
        case passwordOnSubmit
        case verifiedPasswordOnSubmit
        
        case passwordTextClear
        case verifiedPasswordTextClear
        
        case resetPasswordButtonTapped
        case backButtonTapped
        
        case successReset, failReset(LoginError)
        case onDismiss
    }
    
    @Dependency(\.validationClient) var validationClient
    @Dependency(\.authClient) var authClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .passwordChanged(password):
                state.password = password
                return .none
                
            case let .verifiedPasswordChanged(verifiedPassword):
                state.verifiedPassword = verifiedPassword
                return .none
                
            case let .passwordFocused(isFocused):
                state.passwordState = isFocused ? .focused : (state.password.isEmpty ? .empty : .normal)
                state.passwordErrorMessage = nil
                return .none
                
            case let .verifiedPasswordFocused(isFocueed):
                state.verifiedPasswordState = isFocueed ? .focused : (state.verifiedPassword.isEmpty ? .empty : .normal)
                state.verifiedPasswordErrorMessage = nil
                return .none
                
            case .passwordOnSubmit:
                if state.password.isEmpty {
                    state.passwordState = .empty
                    state.passwordErrorMessage = nil
                } else if !validationClient.validatePassword(state.password) {
                    state.passwordState = .invalid
                    state.passwordErrorMessage = "이메일 형식이 잘못되었습니다."
                } else {
                    state.passwordState = .valid
                    state.passwordErrorMessage = nil
                }
                return .none
            
            case .verifiedPasswordOnSubmit:
                if state.verifiedPassword.isEmpty {
                    state.verifiedPasswordState = .empty
                    state.verifiedPasswordErrorMessage = nil
                } else if state.verifiedPassword == state.password {
                    state.passwordState = .valid
                    state.passwordErrorMessage = nil
                } else {
                    state.passwordState = .invalid
                    state.passwordErrorMessage = "비밀번호가 일치하지 않습니다."
                }
                return .none
                
            case .passwordTextClear:
                state.password = ""
                state.passwordState = .empty
                state.passwordErrorMessage = nil
                return .none
                
            case .verifiedPasswordTextClear:
                state.verifiedPassword = ""
                state.verifiedPasswordState = .empty
                state.verifiedPasswordErrorMessage = nil
                return .none
                
            case .resetPasswordButtonTapped:
                state.isResetPasswordLoading = true
                return .none
                
            case .backButtonTapped, .onDismiss:
                return .none
                
            case .successReset:
                state.isResetPasswordLoading = false
                // 다음 화면
                
                return .none
                
            case let .failReset(error):
                state.isResetPasswordLoading = false
                
                return .none
            }
        }
    }
}
