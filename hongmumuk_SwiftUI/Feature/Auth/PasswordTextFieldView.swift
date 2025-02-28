//
//  PasswordTextFieldView.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 2/28/25.
//

import ComposableArchitecture
import SwiftUI

struct PasswordTextFieldView: View {
    var isPasswordFocused: FocusState<Bool>.Binding
    @ObservedObject var viewStore: ViewStoreOf<EmailLoginFeature>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            passwordTextField
            
            if let passwordError = viewStore.passwordErrorMessage {
                passwordErrorView(passwordError)
            }
        }
    }
    
    private var passwordTextField: some View {
        HStack(alignment: .top) {
            ZStack {
                passwordBackgroundView
                
                passwordBorderView
                    .padding(.top, 47)
                
                HStack {
                    ZStack {
                        passwordNormalTextField
                            .padding(.leading, 12)
                            .opacity(viewStore.passwordVisible ? 1 : 0)
                        
                        passwordSecureTextField
                            .padding(.leading, 12)
                            .opacity(viewStore.passwordVisible ? 0 : 1)
                    }
                    
                    if !viewStore.password.isEmpty, isPasswordFocused.wrappedValue {
                        passwordClearButton
                            .padding(.trailing, 12)
                    }
                    
                    if !viewStore.password.isEmpty, isPasswordFocused.wrappedValue {
                        passwordInvisibleButton
                            .padding(.trailing, 12)
                            .animation(.none, value: viewStore.passwordVisible)
                    }
                }
            }
        }
    }
    
    private var passwordBackgroundView: some View {
        UnevenRoundedRectangle(topLeadingRadius: 12, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 12)
            .fill(CommonTextFieldStyle.backgroundColor(for: viewStore.passwordState))
            .frame(height: 47)
    }
    
    private var passwordBorderView: some View {
        Divider()
            .background(CommonTextFieldStyle.borderColor(for: viewStore.passwordState))
            .frame(height: 1)
    }
    
    private var passwordNormalTextField: some View {
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
        .foregroundColor(CommonTextFieldStyle.textColor(for: viewStore.passwordState))
    }
    
    private var passwordSecureTextField: some View {
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
        .foregroundColor(CommonTextFieldStyle.textColor(for: viewStore.passwordState))
    }
    
    private var passwordClearButton: some View {
        Button(action: { viewStore.send(.passwordTextClear) }) {
            Image("TextFieldClearIcon")
                .frame(width: 20, height: 20)
        }
    }
    
    private var passwordInvisibleButton: some View {
        Button(action: { viewStore.send(.passwordVisibleToggled) }) {
            Image(viewStore.passwordVisible ? "TextFieldVisibleIcon" : "TextFieldInvisibleIcon")
                .frame(width: 20, height: 20)
        }
    }
    
    private func passwordErrorView(_ errorMessage: String) -> some View {
        Text(errorMessage)
            .fontStyle(Fonts.caption1Medium)
            .foregroundStyle(Colors.SemanticColor.negative)
    }
}
