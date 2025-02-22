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
                        .foregroundStyle(viewStore.emailTextColor)
                        .padding(.leading, 24)
                        .padding(.top, geometry.size.height * 0.04)
                    
                    EmailInputField(isEmailFocused: $isEmailFocused, viewStore: viewStore)
                        .padding(.horizontal, 24)
                        .padding(.top, 8)
                    
                    Text("비밀번호")
                        .fontStyle(Fonts.heading2Bold)
                        .foregroundStyle(viewStore.passwordTextColor)
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

// Email Input Field
struct EmailInputField: View {
    var isEmailFocused: FocusState<Bool>.Binding
    @ObservedObject var viewStore: ViewStoreOf<EmailLoginFeature>
    
    var body: some View {
        HStack(alignment: .top) {
            ZStack {
                UnevenRoundedRectangle(topLeadingRadius: 12, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 12)
                    .fill(viewStore.emailBackgroundColor)
                    .frame(height: 47)
                
                Divider()
                    .background(viewStore.emailBorderColor)
                    .frame(height: 1)
                    .padding(.top, 47)
                
                HStack {
                    TextField("학교 이메일을 입력해 주세요", text: Binding(
                        get: { viewStore.email },
                        set: { viewStore.send(.emailChanged($0)) }
                    ))
                    .focused(isEmailFocused)
                    .onSubmit { viewStore.send(.emailOnSubmit) }
                    .onChange(of: isEmailFocused.wrappedValue) { isFocused in
                        viewStore.send(.emailFocused(isFocused))
                        
                        if !isFocused {
                            viewStore.send(.emailOnSubmit)
                        }
                    }
                    .font(Fonts.body1Medium.toFont())
                    .foregroundColor(viewStore.emailTextColor)
                    .padding(.leading, 12)
                    
                    if !viewStore.email.isEmpty, isEmailFocused.wrappedValue {
                        Button(action: { viewStore.send(.emailTextClear) }) {
                            Image("TextFieldClearIcon")
                                .frame(width: 20, height: 20)
                                .padding(.trailing, 12)
                        }
                    }
                }
            }
            
            Text("@")
                .fontStyle(Fonts.heading3Medium)
                .foregroundStyle(Colors.GrayScale.normal)
                .frame(minHeight: 48)
                .padding(.leading, 8)
        
            ZStack {
                UnevenRoundedRectangle(topLeadingRadius: 12, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 12)
                    .fill(Color(hex: "FAFBFE"))
                    .frame(height: 47)
                
                Divider()
                    .background(Colors.Border.strong)
                    .frame(height: 1)
                    .padding(.top, 47)
                
                Text("g.hongik.ac.kr")
                    .fontStyle(Fonts.body1Medium)
                    .foregroundStyle(Colors.GrayScale.normal)
                    .padding(.leading, 12)
                    .padding(.trailing, 9)
            }
            .padding(.leading, 8)
            .fixedSize(horizontal: true, vertical: false)
        }
    }
}

// Password Input Field
struct PasswordInputField: View {
    var isPasswordFocused: FocusState<Bool>.Binding
    @ObservedObject var viewStore: ViewStoreOf<EmailLoginFeature>
    
    var body: some View {
        HStack(alignment: .top) {
            ZStack {
                UnevenRoundedRectangle(topLeadingRadius: 12, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 12)
                    .fill(viewStore.passwordBackgroundColor)
                    .frame(height: 47)
                
                Divider()
                    .background(viewStore.passwordBorderColor)
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
                        .foregroundColor(viewStore.passwordTextColor)
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
                        .foregroundColor(viewStore.passwordTextColor)
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
    }
}
