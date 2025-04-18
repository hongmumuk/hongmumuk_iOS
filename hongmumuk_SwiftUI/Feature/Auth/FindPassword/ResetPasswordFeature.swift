//
//  ResetPasswordFeature.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 3/1/25.
//

import ComposableArchitecture
import SwiftUI

struct ResetPasswordFeature: Reducer {
    struct State: Equatable {
        var password: String = ""
        var passwordErrorMessage: String? = nil
        var passwordState: TextFieldState = .empty
        var passwordVisible: Bool = false
        
        var verifiedPassword: String = ""
        var verifiedPasswordMessage: String? = nil
        var verifiedPasswordState: TextFieldState = .empty
        var verifiedPasswordVisible: Bool = false
        
        var resetPasswordError: LoginError? = nil
        
        var isResetPasswordLoading: Bool = false
        
        var isResetPasswordButtonEnabled: Bool {
            return !isResetPasswordLoading && resetPasswordError == nil && passwordState == .valid && verifiedPasswordState == .passwordVerified
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
        
        case passwordVisibleToggled
        case verifiedVisibleToggled
        
        case continueButtonTapped
        
        case successReset, failReset(LoginError)
    }
    
    @Dependency(\.validationClient) var validationClient
    @Dependency(\.authClient) var authClient
    @Dependency(\.userDefaultsClient) var userDefaultsClient
    
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
                state.verifiedPasswordMessage = nil
                return .none
                
            case .passwordOnSubmit:
                if state.verifiedPassword == state.password {
                    state.verifiedPasswordState = .passwordVerified
                    state.verifiedPasswordMessage = "passwords_match".localized()
                }
                if state.password.isEmpty {
                    state.passwordState = .empty
                    state.passwordErrorMessage = nil
                } else if !validationClient.validatePassword(state.password) {
                    state.passwordState = .invalid
                    state.passwordErrorMessage = "영문, 숫자 포함 8~20자 이내로 입력해 주세요."
                } else {
                    state.passwordState = .valid
                    state.passwordErrorMessage = nil
                }
                return .none
            
            case .verifiedPasswordOnSubmit:
                if state.verifiedPassword.isEmpty {
                    state.verifiedPasswordState = .empty
                    state.verifiedPasswordMessage = nil
                } else if state.verifiedPassword == state.password {
                    state.verifiedPasswordState = .passwordVerified
                    state.verifiedPasswordMessage = "passwords_match".localized()
                } else {
                    state.verifiedPasswordState = .invalid
                    state.verifiedPasswordMessage = "passwords_do_not_match".localized()
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
                state.verifiedPasswordMessage = nil
                return .none
                
            case .passwordVisibleToggled:
                state.passwordVisible.toggle()
                return .none
                
            case .verifiedVisibleToggled:
                state.verifiedPasswordVisible.toggle()
                return .none
                
            case .continueButtonTapped:

                state.isResetPasswordLoading = true
                
                return .run { [password = state.password] send in
                    do {
                        let savedEmail = await userDefaultsClient.getString(.findPassword)
                        let body = ResetPasswordModel(email: savedEmail, newPassword: password)
                        
                        if try await authClient.resetPassword(body) {
                            await send(.successReset)
                        }
                    } catch {
                        if let resetError = error as? LoginError {
                            await send(.failReset(resetError))
                        }
                    }
                }
                
            case .successReset:
                state.isResetPasswordLoading = false
                return .none
                
            case let .failReset(error):
                state.isResetPasswordLoading = false
                print("비밀번호를 바꿀 수 없습니다.")
                
                return .none
            }
        }
    }
}
