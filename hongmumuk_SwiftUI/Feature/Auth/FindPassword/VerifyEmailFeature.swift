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
        
        var remainingTime: Int = 0
        var sendCodeTimerActive: Bool = false
        
        var isSendCodeButtonEnabled: Bool {
            emailState == .valid && !sendCodeTimerActive && !isSendCodeLoading
        }

        var isVerifyCodeButtonEnabled: Bool {
            emailState == .valid && codeState == .valid
        }

        var isContinueButtonEnabled: Bool {
            emailState == .codeVerified && codeState == .disabled
        }
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
        
        case stopSendCodeTimer
        case updateSendCodeTimer(Int)
        
        case successSend, failSend(LoginError)
        case successVerify, failVerify(LoginError)
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
                let newEmail = "\(state.email)@g.hongik.ac.kr"

                Task {
                    await userDefaultsClient.setString(newEmail, .findPassword)
                    let savedEmail = await userDefaultsClient.getString(.findPassword)
                    print(savedEmail)
                }

                return .none
                
            case .successSend:
                state.isSendCodeLoading = false
                state.sendCodeTimerActive = true
                state.remainingTime = 180

                return .run { send in
                    var timeLeft = 180
                    while timeLeft > 0 {
                        try await Task.sleep(nanoseconds: 1_000_000_000)
                        timeLeft -= 1
                        await send(.updateSendCodeTimer(timeLeft))
                    }
                    await send(.stopSendCodeTimer)
                }
                
            case let .updateSendCodeTimer(timeLeft):
                state.remainingTime = timeLeft
                return .none
                
            case .stopSendCodeTimer:
                state.sendCodeTimerActive = false
                state.remainingTime = 0
                return .none
                
            case let .failSend(error):
                state.isSendCodeLoading = false
                state.sendCodeError = error
                if state.sendCodeError != nil {
                    state.emailState = .loginError
                }
                
                if error == .userNotFound {
                    state.emailErrorMessage = "등록되지 않은 이메일입니다."
                } else {
                    state.emailErrorMessage = "인증번호를 전송할 수 없습니다."
                }
   
                return .none
                
            case .successVerify:
                state.isVerifyCodeLoading = false
                state.emailState = .codeVerified
                state.codeState = .disabled
                state.emailErrorMessage = "email_verification_complete".localized()
                
                return .none
                
            case let .failVerify(error):
                state.isVerifyCodeLoading = false
                state.verifyCodeError = error
                if state.verifyCodeError != nil {
                    state.codeState = .loginError
                }
                if error == .invalidCode {
                    state.codeErrorMessage = "인증번호가 올바르지 않습니다."
                } else if error == .expiredCode {
                    state.codeErrorMessage = "인증번호가 만료되었습니다."
                }
                return .none
            }
        }
    }
}
