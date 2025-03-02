//
//  VerifyEmailFeature.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 3/1/25.
//

import ComposableArchitecture
import SwiftUI

struct VerifyEmailFeature: Reducer {
    // ActiveScreen은 EmailLoginFeature에서 관리
    struct State: Equatable {
        var email: String = ""
        var emailErrorMessage: String? = nil
        var emailState: TextFieldState = .empty
        
        var code: String = ""
        var codeErrorMessage: String? = nil
        var codeState: TextFieldState = .empty
        
        // loginError에 따라 인증 됐는지 여부 파악
        var sendCodeError: LoginError? = nil
        var verifyCodeError: LoginError? = nil
        
        var isSendCodeLoading: Bool = false
        var isVerifyCodeLoading: Bool = false
        var isContinueLoading: Bool = false
        
        var isSendCodeButtonEnabled: Bool {
            emailState == .valid
        }

        var isVerifyCodeButtonEnabled: Bool {
            emailState == .valid && codeState == .valid
        }

        var isContinueButtonEnabled: Bool = false
    }
    
    enum Action: Equatable {
        case emailChanged(String)
        case codeChanged(String)
        
        case emailFocused(Bool)
        case codeFocused(Bool)
        
        case emailOnSubmit
        case codeOnSubmit
        
        case emailTextClear
        case codeTextClear
        
        case sendCodeButtonTapped
        case verifyCodeButtonTapped
        case continueButtonTapped
        case backButtonTapped
        
        case successSend, failSend(LoginError)
        case successVerify, failVerify(LoginError)
        case onDismiss
    }
    
    @Dependency(\.validationClient) var validationClient
    @Dependency(\.authClient) var authClient
    @Dependency(\.userDefaultsClient) var userDefaultsClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .emailChanged(email):
                state.email = email
                return .none
                
            case let .codeChanged(code):
                state.code = code
                return .none
                
            case let .emailFocused(isFocused):
                state.emailState = isFocused ? .focused : (state.email.isEmpty ? .empty : .normal)
                state.emailErrorMessage = nil
                if state.sendCodeError != nil {
                    state.sendCodeError = nil
                }
                return .none
                
            case let .codeFocused(isFocueed):
                state.codeState = isFocueed ? .focused : (state.code.isEmpty ? .empty : .normal)
                state.codeErrorMessage = nil
                if state.verifyCodeError != nil {
                    state.verifyCodeError = nil
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
            
            case .codeOnSubmit:
                if state.code.isEmpty {
                    state.codeState = .empty
                    state.codeErrorMessage = nil
                } else if state.code.count != 6 {
                    state.codeState = .invalid
                    state.codeErrorMessage = "6자리 숫자를 입력해주세요"
                } else {
                    state.codeState = .valid
                    state.codeErrorMessage = nil
                }
                return .none
                
            case .emailTextClear:
                state.email = ""
                state.emailState = .empty
                state.emailErrorMessage = nil
                return .none
                
            case .codeTextClear:
                state.code = ""
                state.codeState = .empty
                state.codeErrorMessage = nil
                return .none
                
            case .sendCodeButtonTapped:
                state.isSendCodeLoading = true
                let newEmail = "\(state.email)@g.hongik.ac.kr"
                let body = SendVerifyCodeModel(email: newEmail, join: false)

                return .run { send in
                    do {
                        if try await authClient.sendVerificationEmail(body) {
                            await userDefaultsClient.setString(newEmail, .findPassword)
                            await send(.successSend)
                        }
                    } catch {
                        if let sendError = error as? LoginError {
                            await send(.failSend(sendError))
                        }
                    }
                }
                
            case .verifyCodeButtonTapped:
                state.isVerifyCodeLoading = true
                let newEmail = "\(state.email)@g.hongik.ac.kr"
                let body = VerifyEmailModel(email: newEmail, code: state.code)
                
                return .run { send in
                    do {
                        if try await authClient.verifyEmailCode(body) {
                            await send(.successVerify)
                        }
                    } catch {
                        if let loginError = error as?
                            LoginError
                        {
                            await send(.failVerify(loginError))
                        }
                    }
                }
                
            case .continueButtonTapped:
                // 다음 화면으로 넘어가야하는데 이걸 부모뷰에서 조정할지...
                return .none
                
            case .backButtonTapped, .onDismiss:
                return .none
                
            case .successSend:
                state.isSendCodeLoading = false
                // 보내고 UI 업데이트
                return .none
                
            case let .failSend(error):
                state.isSendCodeLoading = false
                state.sendCodeError = error
                if state.sendCodeError != nil {
                    state.emailState = .loginError
                }
                state.emailErrorMessage = error == .userNotFound ? "가입된 계정이 없습니다. 이메일을 다시 확인해주세요." : nil
                return .none
                
            case .successVerify:
                state.isVerifyCodeLoading = false
                state.isContinueButtonEnabled = true
                state.emailState = .codeVerified
                state.codeState = .disabled
                
                return .none
                
            case let .failVerify(error):
                state.isVerifyCodeLoading = false
                state.codeState = .codeInvalid
                state.codeErrorMessage = error == .invalidCode ? "인증번호가 잘못 입력되었습니다." : nil
                state.codeErrorMessage = error == .noVerificationRecord ? "인증번호가 전송되지 않았습니다." : nil
                
                return .none
            }
        }
    }
}
