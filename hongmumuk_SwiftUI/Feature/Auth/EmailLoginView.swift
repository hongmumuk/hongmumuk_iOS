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
    
    @ObservedObject var viewStore: ViewStoreOf<EmailLoginFeature>
    @FocusState private var isEmailFocused: Bool
    @FocusState private var isPasswordFocused: Bool
    
    init(store: StoreOf<EmailLoginFeature>) {
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
                        .foregroundStyle(CommonTextFieldStyle.textColor(
                            isFocused: viewStore.emailFocused,
                            isEmpty: viewStore.email.isEmpty,
                            isValid: viewStore.emailValid,
                            loginError: viewStore.loginError
                        ))
                        .padding(.leading, 24)
                        .padding(.top, geometry.size.height * 0.04)
                    
                    EmailTextFieldView(isEmailFocused: $isEmailFocused, viewStore: viewStore)
                        .padding(.horizontal, 24)
                        .padding(.top, 8)
                    
                    Text("비밀번호")
                        .fontStyle(Fonts.heading2Bold)
                        .foregroundStyle(CommonTextFieldStyle.textColor(
                            isFocused: viewStore.passwordFocused,
                            isEmpty: viewStore.password.isEmpty,
                            isValid: viewStore.passwordValid,
                            loginError: viewStore.loginError
                        ))
                        .padding(.leading, 24)
                        .padding(.top, 24)
                    
                    PasswordInputField(isPasswordFocused: $isPasswordFocused, viewStore: viewStore)
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
                        
                        Button(action: { print("회원가입 화면으로 이동") }) {
                            Text("회원가입")
                                .fontStyle(Fonts.body1Medium)
                                .foregroundStyle(Colors.GrayScale.alternative)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Divider()
                            .background(Colors.GrayScale.alternative)
                            .frame(width: 1, height: 12)
                        
                        Button(action: { print("비밀번호 찾기 화면으로 이동") }) {
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
            .navigationTitle("이메일로 로그인")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("이메일로 로그인")
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
                isPasswordFocused = false
            }
        }
    }
}

// Password Input Field
struct PasswordInputField: View {
    var isPasswordFocused: FocusState<Bool>.Binding
    @ObservedObject var viewStore: ViewStoreOf<EmailLoginFeature>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                ZStack {
                    UnevenRoundedRectangle(topLeadingRadius: 12, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 12)
                        .fill(CommonTextFieldStyle.backgroundColor(
                            isFocused: viewStore.passwordFocused,
                            isEmpty: viewStore.password.isEmpty,
                            isValid: viewStore.passwordValid,
                            loginError: viewStore.loginError
                        ))
                        .frame(height: 47)
                    
                    Divider()
                        .background(CommonTextFieldStyle.borderColor(
                            isFocused: viewStore.passwordFocused,
                            isEmpty: viewStore.password.isEmpty,
                            isValid: viewStore.passwordValid,
                            loginError: viewStore.loginError
                        ))
                        .frame(height: 1)
                        .padding(.top, 47)
                    
                    HStack {
                        ZStack {
                            TextField(
                                "영문, 숫자 포함 8-20자 이내로 입력해 주세요",
                                text: Binding(
                                    get: { viewStore.password },
                                    set: { viewStore.send(.passwordChanged($0)) }
                                )
                            )
                            .focused(isPasswordFocused)
                            .onSubmit { viewStore.send(.passwordOnSubmit) }
                            .onChange(of: isPasswordFocused.wrappedValue) { isFocused in
                                viewStore.send(.passwordFocused(isFocused))
                                
                                if !isFocused {
                                    viewStore.send(.passwordOnSubmit)
                                }
                            }
                            .font(Fonts.body1Medium.toFont())
                            .foregroundColor(CommonTextFieldStyle.textColor(
                                isFocused: viewStore.passwordFocused,
                                isEmpty: viewStore.password.isEmpty,
                                isValid: viewStore.passwordValid,
                                loginError: viewStore.loginError
                            ))
                            .padding(.leading, 12)
                            .opacity(viewStore.passwordVisible ? 1 : 0)
                            
                            SecureField(
                                "영문, 숫자 포함 8-20자 이내로 입력해 주세요",
                                text: Binding(
                                    get: { viewStore.password },
                                    set: { viewStore.send(.passwordChanged($0)) }
                                )
                            )
                            .focused(isPasswordFocused)
                            .onSubmit { viewStore.send(.passwordOnSubmit) }
                            .onChange(of: isPasswordFocused.wrappedValue) { isFocused in
                                viewStore.send(.passwordFocused(isFocused))
                            }
                            .font(Fonts.body1Medium.toFont())
                            .foregroundColor(CommonTextFieldStyle.textColor(
                                isFocused: viewStore.passwordFocused,
                                isEmpty: viewStore.password.isEmpty,
                                isValid: viewStore.passwordValid,
                                loginError: viewStore.loginError
                            ))
                            .padding(.leading, 12)
                            .opacity(viewStore.passwordVisible ? 0 : 1)
                        }
                        
                        if !viewStore.password.isEmpty, isPasswordFocused.wrappedValue {
                            Button(action: { viewStore.send(.passwordTextClear) }) {
                                Image("TextFieldClearIcon")
                                    .frame(width: 20, height: 20)
                                    .padding(.trailing, 12)
                            }
                        }
                        
                        if !viewStore.password.isEmpty, isPasswordFocused.wrappedValue {
                            Button(action: { viewStore.send(.passwordVisibleToggled) }) {
                                Image(viewStore.passwordVisible ? "TextFieldVisibleIcon" : "TextFieldInvisibleIcon")
                                    .frame(width: 20, height: 20)
                                    .padding(.trailing, 12)
                                    .animation(.none, value: viewStore.passwordVisible)
                            }
                        }
                    }
                }
            }
            
            if let passwordError = viewStore.passwordErrorMessage {
                Text(passwordError)
                    .fontStyle(Fonts.caption1Medium)
                    .foregroundStyle(Colors.SemanticColor.negative)
            }
        }
    }
}
