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
    
    init(store: StoreOf<EmailLoginFeature>) {
        self.store = store
        viewStore = ViewStore(store, observe: { $0 })
    }
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                VStack(alignment: .leading) {
                    Divider()
                        .background(Colors.Border.neutral)
                        .frame(height: 1)
                    
                    Text("이메일")
                        .fontStyle(Fonts.heading2Bold)
                        .foregroundStyle(viewStore.emailState.textColor)
                        .padding(.leading, 24)
                        .padding(.top, geometry.size.height * 0.04)
                    
                    HStack(alignment: .top) {
                        InputField(
                            placeholder: "학교 이메일을 입력해주세요",
                            text: Binding(
                                get: { viewStore.emailState.text },
                                set: { viewStore.send(.emailChanged($0)) }
                            ),
                            backgroundColor: viewStore.emailState.backgroundColor,
                            borderColor: viewStore.emailState.borderColor,
                            textColor: viewStore.emailState.textColor,
                            errorMessage: viewStore.emailState.errorMessage,
                            onSubmit: { viewStore.send(.validateField(.email)) },
                            onFocusChange: { isFocused in
                                if isFocused {
                                    viewStore.send(.focusField(.email))
                                } else {
                                    viewStore.send(.validateField(.email))
                                }
                            },
                            clearText: { viewStore.send(.clearField(.email)) },
                            toggleVisibility: nil
                        )
                        
                        Text("@")
                            .fontStyle(Fonts.heading3Medium)
                            .foregroundStyle(Colors.GrayScale.normal)
                            .frame(minHeight: 48)
                            .padding(.leading, -16)
                        
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
                        }
                        .frame(width: geometry.size.width * 0.24, height: 48)
                        .padding(.trailing, 24)
                        .padding(.leading, 8)
                    }
                    .padding(.top, 8)
                    
                    Text("비밀번호")
                        .fontStyle(Fonts.heading2Bold)
                        .foregroundStyle(viewStore.passwordState.textColor)
                        .padding(.leading, 24)
                        .padding(.top, 24)
                    
                    InputField(
                        placeholder: "영문, 숫자 포함 8-20자 이내로 입력해주세요",
                        text: Binding(
                            get: { viewStore.passwordState.text },
                            set: { viewStore.send(.passwordChanged($0)) }
                        ),
                        isSecure: !viewStore.isPasswordVisible,
                        backgroundColor: viewStore.passwordState.backgroundColor,
                        borderColor: viewStore.passwordState.borderColor,
                        textColor: viewStore.passwordState.textColor,
                        errorMessage: viewStore.passwordState.errorMessage,
                        onSubmit: { viewStore.send(.validateField(.password)) },
                        onFocusChange: { isFocused in
                            if isFocused {
                                viewStore.send(.focusField(.password))
                            } else {
                                viewStore.send(.validateField(.password))
                            }
                        },
                        clearText: { viewStore.send(.clearField(.password)) },
                        toggleVisibility: { viewStore.send(.togglePasswordVisibility) }
                    )
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
                        Button(action: { print("버튼이 눌렸습니다!") }) {
                            Text("회원가입")
                                .fontStyle(Fonts.body1Medium)
                                .foregroundStyle(Colors.GrayScale.alternative)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Divider()
                            .background(Colors.GrayScale.alternative)
                            .frame(height: geometry.size.height * 0.02)
                        
                        Button(action: { print("버튼이 눌렸습니다!") }) {
                            Text("비밀번호 찾기")
                                .fontStyle(Fonts.body1Medium)
                                .foregroundStyle(Colors.GrayScale.alternative)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.05)
                    .padding(.top, 12)
                    
                    Spacer()
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
            }
        }
    }
}

struct InputField: View {
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    @FocusState private var isFocused: Bool
    let backgroundColor: Color
    let borderColor: Color
    let textColor: Color
    let errorMessage: String?
    let onSubmit: () -> Void
    let onFocusChange: (Bool) -> Void
    let clearText: () -> Void
    let toggleVisibility: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                UnevenRoundedRectangle(topLeadingRadius: 12, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 12)
                    .fill(backgroundColor)
                    .frame(height: 47)
                
                Divider()
                    .background(borderColor)
                    .frame(height: 1)
                    .padding(.top, 47)
                
                HStack {
                    if isSecure {
                        SecureField(placeholder, text: $text)
                            .focused($isFocused)
                            .onSubmit(onSubmit)
                            .onChange(of: isFocused, perform: onFocusChange)
                            .font(Fonts.body1Medium.toFont())
                            .foregroundColor(textColor)
                            .padding(.leading, 12)
                    } else {
                        TextField(placeholder, text: $text)
                            .focused($isFocused)
                            .onSubmit(onSubmit)
                            .onChange(of: isFocused, perform: onFocusChange)
                            .font(Fonts.body1Medium.toFont())
                            .foregroundColor(textColor)
                            .padding(.leading, 12)
                    }
                    
                    if !text.isEmpty, isFocused {
                        Button(action: { clearText() }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, 12)
                        }
                    }
                    
                    if !text.isEmpty, isFocused {
                        if let toggleVisibility {
                            Button(action: { toggleVisibility() }) {
                                Image(systemName: isSecure ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 12)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 24)
            
            if let error = errorMessage {
                if !isFocused {
                    Text(error)
                        .fontStyle(Fonts.caption1Medium)
                        .foregroundColor(Colors.SemanticColor.negative)
                        .padding(.leading, 24)
                }
            }
        }
    }
}
