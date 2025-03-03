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
    
    @ObservedObject var viewStore: ViewStoreOf<VerifyEmailFeature>
    @FocusState private var isEmailFocused: Bool
    @FocusState private var isCodeFocused: Bool
    
    init(store: StoreOf<VerifyEmailFeature>) {
        self.store = store
        viewStore = ViewStore(store, observe: { $0 })
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(alignment: .leading) {
                    Divider()
                        .background(Colors.Border.neutral)
                        .frame(height: 1)
                    
                    Text("이메일")
                        .fontStyle(Fonts.heading2Bold)
                        .foregroundStyle(CommonTextFieldStyle.textColor(for: viewStore.emailState))
                        .padding(.leading, 24)
                        .padding(.top, geometry.size.height * 0.04)
                    
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
                    
                    NextButton(title: "비밀번호 재설정하러 가기", isActive: viewStore.isContinueButtonEnabled) {
                        if viewStore.isContinueButtonEnabled {
                            viewStore.send(.continueButtonTapped)
                        }
                    }
                    .frame(height: 60)
                    .padding(.horizontal, 24)
                    .padding(.bottom, geometry.size.height * 0.1)
                }
            }
            .navigationTitle("비밀번호 찾기")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("비밀번호 찾기")
                        .fontStyle(Fonts.heading1Bold)
                        .foregroundColor(Colors.GrayScale.normal)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { viewStore.send(.backButtonTapped) }) {
                        Image("backButton")
                            .resizable()
                            .frame(width: 36, height: 36)
                    }
                    .padding(.leading, 4)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .onTapGesture {
                isEmailFocused = false
                isCodeFocused = false
            }
        }
    }
}
