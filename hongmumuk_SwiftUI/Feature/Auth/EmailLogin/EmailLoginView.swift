//
//  EmailLoginView.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 2/13/25.
//

import ComposableArchitecture
import SwiftUI

struct EmailLoginView: View {
    let store: StoreOf<EmailLoginFeature>
    let parentStore: StoreOf<RootFeature>
    
    @ObservedObject var viewStore: ViewStoreOf<EmailLoginFeature>
    @ObservedObject var parentViewStore: ViewStoreOf<RootFeature>
    @FocusState private var isEmailFocused: Bool
    @FocusState private var isPasswordFocused: Bool
    
    init(store: StoreOf<EmailLoginFeature>, parentStore: StoreOf<RootFeature>) {
        self.store = store
        self.parentStore = parentStore
        viewStore = ViewStore(store, observe: { $0 })
        parentViewStore = ViewStore(parentStore, observe: { $0 })
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                LoginHeaderView(
                    title: "이메일로 로그인",
                    action: {
                        parentViewStore.send(
                            .onDismiss
                        )
                    }
                )
                
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
                    placeholder: "학교 이메일을 입력해주세요",
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
                
                Text("비밀번호")
                    .fontStyle(Fonts.heading2Bold)
                    .foregroundStyle(CommonTextFieldStyle.textColor(for: viewStore.passwordState))
                    .padding(.leading, 24)
                    .padding(.top, 24)
                
                CommonTextFieldView(
                    isFocused: $isPasswordFocused,
                    text: viewStore.password,
                    state: viewStore.passwordState,
                    message: viewStore.passwordErrorMessage,
                    placeholder: "영문, 숫자 포함 8~20자 이내로 입력해 주세요",
                    isSecure: !viewStore.passwordVisible,
                    showAtSymbol: false,
                    showSuffix: false,
                    suffixText: "",
                    onTextChanged: { viewStore.send(.passwordChanged($0)) },
                    onFocusedChanged: { viewStore.send(.passwordFocused($0)) },
                    onSubmit: { viewStore.send(.passwordOnSubmit) },
                    onClear: { viewStore.send(.passwordTextClear) },
                    onToggleVisibility: { viewStore.send(.passwordVisibleToggled) }
                )
                .padding(.horizontal, 24)
                .padding(.top, 8)
                
                NextButton(title: "로그인", isActive: viewStore.isSigninEnabled) {
                    if viewStore.isSigninEnabled {
                        viewStore.send(.signInButtonTapped)
                    }
                }
                .frame(height: 60)
                .padding(.horizontal, 24)
                .padding(.top, geometry.size.height * 0.07)
                
                HStack(alignment: .center, spacing: 12) {
                    Spacer()
                    
                    Button(action: { parentViewStore.send(.navigationTo(.signup)) }) {
                        Text("회원가입")
                            .fontStyle(Fonts.body1Medium)
                            .foregroundStyle(Colors.GrayScale.alternative)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Divider()
                        .background(Colors.GrayScale.alternative)
                        .frame(width: 1, height: 12)
                    
                    Button(action: { parentViewStore.send(.navigationTo(.verifyEmail)) }) {
                        Text("비밀번호 찾기")
                            .fontStyle(Fonts.body1Medium)
                            .foregroundStyle(Colors.GrayScale.alternative)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Spacer()
                }
                .padding(.top, 12)
                
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            isEmailFocused = false
            isPasswordFocused = false
        }
    }
}
