//
//  SignupPasswordFeature.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 3/2/25.
//

import ComposableArchitecture
import SwiftUI

struct SignupPasswordFeature: Reducer {
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
        
        var isContinueLoading: Bool = false
        
        var isContinueButtonEnabled: Bool {
            passwordState == .valid && verifiedPasswordState == .codeVerified
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
        case backButtonTapped
        
        case successJoin, failJoin(LoginError)
    }
    
    @Dependency(\.validationClient) var validationClient
    @Dependency(\.authClient) var authClient
    @Dependency(\.userDefaultsClient) var userDefaultsClient
    @Dependency(\.keychainClient) var keychainClient
    
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
            
            case .verifiedPasswordOnSubmit:
                if state.verifiedPassword.isEmpty {
                    state.verifiedPasswordState = .empty
                    state.verifiedPasswordMessage = nil
                } else if state.verifiedPassword == state.password {
                    state.verifiedPasswordState = .codeVerified
                    state.verifiedPasswordMessage = "비밀번호가 일치합니다."
                } else {
                    state.verifiedPasswordState = .invalid
                    state.verifiedPasswordMessage = "비밀번호가 일치하지 않습니다."
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
                state.isContinueLoading = true
                let password = state.password
                
                return .run { send in
                    do {
                        let savedEmail = await userDefaultsClient.getString(.signup)
                        let body = LoginModel(email: savedEmail, password: password)
                        print(body)
                        let tokenData = try await authClient.signup(body)
                        
                        print(tokenData)

                        await keychainClient.setString(tokenData.accessToken, .accessToken)
                        await keychainClient.setString(tokenData.refreshToken, .refreshToken)

                        await send(.successJoin)
                    } catch {
                        if let signupError = error as? LoginError {
                            print(signupError)
                            await send(.failJoin(signupError))
                        }
                    }
                }
                
            case .backButtonTapped:
                return .none
                
            case .successJoin:
                state.isContinueLoading = false
                // 다음 화면
                
                return .none
                
            case let .failJoin(error):
                state.isContinueLoading = false
                state.verifiedPasswordState = .invalid
                state.verifiedPasswordMessage = error == .userNotFound ? "회원가입에 실패했습니다" : nil
                
                return .none
            }
        }
    }
}
