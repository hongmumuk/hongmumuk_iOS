//
//  SignupEmailView.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 3/2/25.
//

import ComposableArchitecture
import SwiftUI

struct SignupEmailView: View {
    let store: StoreOf<SignupEmailFeature>
    
    @ObservedObject var viewStore: ViewStoreOf<SignupEmailFeature>
    
    @FocusState private var isEmailFocused: Bool
    @FocusState private var isCodeFocused: Bool
    
    init(store: StoreOf<SignupEmailFeature>) {
        self.store = store
        viewStore = ViewStore(store, observe: { $0 })
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    scrollView
                    
                    VStack {
                        Spacer()
                        
                        NextButton(title: "다음으로", isActive: viewStore.isContinueButtonEnabled) {
                            if viewStore.isContinueButtonEnabled {
                                viewStore.send(.continueButtonTapped)
                            }
                        }
                        .frame(height: 60)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 60)
                    }
                    .ignoresSafeArea(.keyboard)
                }
            }
            .navigationTitle("회원가입")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("회원가입")
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

    private var scrollView: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading) {
                    SignupHeaderView(
                        activeStep: 2,
                        title: "학교 이메일을 입력해 주세요",
                        subtitle: "졸업생, 휴학생인 경우에도 가입 가능합니다."
                    )
                    
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
                    
                    BasicButton(title: "인증번호 발송", isActive: viewStore.isSendCodeButtonEnabled) {
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
