//
//  VerifyEmailView.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 3/1/25.
//

import ComposableArchitecture
import SwiftUI

struct VerifyEmailView: View {
    let store: StoreOf<VerifyEmailFeature>
    let parentStore: StoreOf<RootFeature>
    
    @ObservedObject var viewStore: ViewStoreOf<VerifyEmailFeature>
    @ObservedObject var parentViewStore: ViewStoreOf<RootFeature>
    @FocusState private var isEmailFocused: Bool
    @FocusState private var isCodeFocused: Bool
    
    init(store: StoreOf<VerifyEmailFeature>, parentStore: StoreOf<RootFeature>) {
        self.store = store
        self.parentStore = parentStore
        viewStore = ViewStore(store, observe: { $0 })
        parentViewStore = ViewStore(parentStore, observe: { $0 })
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                LoginHeaderView(title: "비밀번호 찾기", action: { parentViewStore.send(.onDismiss) })
                
                scrollView
                    .padding(.top, 56)
                    
                VStack {
                    Spacer()
                        
                    NextButton(title: "비밀번호 재설정", isActive: viewStore.isContinueButtonEnabled) {
                        if viewStore.isContinueButtonEnabled {
                            viewStore.send(.continueButtonTapped)
                            parentViewStore.send(.navigationTo(.resetPassword))
                        }
                    }
                    .frame(height: 60)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 60)
                }
                .ignoresSafeArea(.keyboard)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            isEmailFocused = false
            isCodeFocused = false
        }
    }

    private var scrollView: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading) {
                    Text("이메일")
                        .fontStyle(Fonts.heading2Bold)
                        .foregroundStyle(CommonTextFieldStyle.textColor(for: viewStore.emailState))
                        .padding(.leading, 24)
                        .padding(.top, geometry.size.height * 0.056)
                    
                    CommonTextFieldView(
                        isFocused: $isEmailFocused,
                        text: viewStore.email,
                        state: viewStore.emailState,
                        message: viewStore.emailErrorMessage,
                        placeholder: "학교 이메일을 입력해 주세요",
                        isSecure: false,
                        showAtSymbol: true,
                        showSuffix: true,
                        suffixText: "g.hongik.ac.kr",
                        onTextChanged: { viewStore.send(.emailChanged($0)) },
                        onFocusedChanged: { viewStore.send(.emailFocused($0)) },
                        onSubmit: { viewStore.send(.emailOnSubmit) },
                        onClear: { viewStore.send(.emailTextClear) }
                    )
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                    
                    BasicButton(
                        title: viewStore.isSendCodeLoading ? "보내는 중..." :
                            viewStore.sendCodeTimerActive ? "\(viewStore.remainingTime)초 후에 재전송" :
                            "인증번호 발송",
                        isActive: viewStore.isSendCodeButtonEnabled
                    ) {
                        if viewStore.isSendCodeButtonEnabled {
                            viewStore.send(.sendCodeButtonTapped)
                        }
                    }
                    .frame(height: 48)
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                    
                    Text("인증번호")
                        .fontStyle(Fonts.heading2Bold)
                        .foregroundStyle(CommonTextFieldStyle.textColor(for: viewStore.codeState))
                        .padding(.leading, 24)
                        .padding(.top, 24)
                    
                    HStack(alignment: .top) {
                        CommonTextFieldView(
                            isFocused: $isCodeFocused,
                            text: viewStore.code,
                            state: viewStore.codeState,
                            message: viewStore.codeErrorMessage,
                            placeholder: "6자리 숫자를 입력해 주세요",
                            isSecure: false,
                            showAtSymbol: false,
                            showSuffix: false,
                            suffixText: "",
                            onTextChanged: { viewStore.send(.codeChanged($0)) },
                            onFocusedChanged: { viewStore.send(.codeFocused($0)) },
                            onSubmit: { viewStore.send(.codeOnSubmit) },
                            onClear: { viewStore.send(.codeTextClear) }
                        )
                        .frame(width: geometry.size.width * 0.62)
                        
                        BasicButton(title: "인증하기", isActive: viewStore.isVerifyCodeButtonEnabled) {
                            if viewStore.isVerifyCodeButtonEnabled {
                                viewStore.send(.verifyCodeButtonTapped)
                            }
                        }
                        .padding(.leading, 8)
                        .frame(height: 48)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                    
                    Spacer()
                }
            }
        }
    }
}
