//
//  PasswordView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 3/7/25.
//

import SwiftUI

import ComposableArchitecture

struct PasswordView: View {
    @ObservedObject var viewStore: ViewStoreOf<ProfileInfoFeature>
    
    @FocusState private var isCurrentPasswordFocused: Bool
    @FocusState private var newCurrentPasswordFocused: Bool
    @FocusState private var newCurrentPasswordConfirmFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            currentPasswordTitle
            currentPasswordTextFieldStack
            
            if viewStore.currentPasswordState == .codeVerified {
                newPasswordTitle
                newPasswordTextFieldStack
                
                newPasswordConfirmTitle
                newPasswordConfirmTextFieldStack
            }
            
            Spacer()
            
            NextButton(title: "비밀번호 변경하기", isActive: viewStore.isButtonEnabled) {
                viewStore.send(.newPasswordConfirmButtonTapped)
            }
            .frame(height: 60)
            .padding(.horizontal, 24)
            .padding(.bottom, 60)
        }
    }
    
    private var currentPasswordTitle: some View {
        Text("현재 비밀번호")
            .fontStyle(Fonts.heading2Bold)
            .foregroundStyle(CommonTextFieldStyle.textColor(for: viewStore.currentPasswordState))
            .padding(.leading, 24)
            .padding(.top, 24)
    }
    
    private var currentPasswordTextFieldStack: some View {
        HStack(alignment: .top, spacing: 8) {
            currentPasswordTextField
            passwordConfirmButton
        }
        .padding(.horizontal, 24)
        .padding(.top, 8)
    }
    
    private var currentPasswordTextField: some View {
        CommonTextFieldView(
            isFocused: $isCurrentPasswordFocused,
            text: viewStore.currentPassword,
            state: viewStore.currentPasswordState,
            message: viewStore.currentPasswordErrorMessage,
            placeholder: "enter_current_password".localized(),
            isSecure: !viewStore.currentPasswordVisible,
            onTextChanged: { viewStore.send(.currentPasswordChanged($0)) },
            onFocusedChanged: { viewStore.send(.currentPasswordFocused($0)) },
            onSubmit: { viewStore.send(.currentPasswordOnSubmit) },
            onClear: { viewStore.send(.currentPasswordTextClear) },
            onToggleVisibility: { viewStore.send(.currentpasswordVisibleToggled) }
        )
    }
    
    private var passwordConfirmButton: some View {
        BasicButton(
            title: viewStore.changeButtonText,
            isActive: viewStore.validChangeButton
        ) {
            viewStore.send(.passwordConfirmButtonTapped)
        }
        .frame(width: 104, height: 48)
        .cornerRadius(12)
    }
    
    private var newPasswordTitle: some View {
        Text("새로운 비밀번호")
            .fontStyle(Fonts.heading2Bold)
            .foregroundStyle(CommonTextFieldStyle.textColor(for: viewStore.newPasswordState))
            .padding(.leading, 24)
            .padding(.top, 24)
    }
    
    private var newPasswordTextFieldStack: some View {
        HStack(alignment: .top, spacing: 8) {
            newPasswordTextField
        }
        .padding(.horizontal, 24)
        .padding(.top, 8)
    }
    
    private var newPasswordTextField: some View {
        CommonTextFieldView(
            isFocused: $newCurrentPasswordFocused,
            text: viewStore.newPassword,
            state: viewStore.newPasswordState,
            message: viewStore.newPasswordErrorMessage,
            placeholder: "reenter_new_password".localized(),
            isSecure: true,
            onTextChanged: { viewStore.send(.newPasswordChanged($0)) },
            onFocusedChanged: { viewStore.send(.newPasswordFocused($0)) },
            onSubmit: { viewStore.send(.newPasswordOnSubmit) },
            onClear: { viewStore.send(.newPasswordTextClear) }
        )
    }
    
    private var newPasswordConfirmTitle: some View {
        Text("새로운 비밀번호 확인")
            .fontStyle(Fonts.heading2Bold)
            .foregroundStyle(CommonTextFieldStyle.textColor(for: viewStore.newPasswordConfirmState))
            .padding(.leading, 24)
            .padding(.top, 24)
    }
    
    private var newPasswordConfirmTextFieldStack: some View {
        HStack(alignment: .top, spacing: 8) {
            newPasswordConfirmTextField
        }
        .padding(.horizontal, 24)
        .padding(.top, 8)
    }
    
    private var newPasswordConfirmTextField: some View {
        CommonTextFieldView(
            isFocused: $newCurrentPasswordConfirmFocused,
            text: viewStore.newPasswordConfirm,
            state: viewStore.newPasswordConfirmState,
            message: viewStore.newPasswordConfirmErrorMessage,
            placeholder: "enter_new_password".localized(),
            isSecure: true,
            onTextChanged: { viewStore.send(.newPasswordConfirmChanged($0)) },
            onFocusedChanged: { viewStore.send(.newPasswordConfirmFocused($0)) },
            onSubmit: { viewStore.send(.newPasswordConfirmOnSubmit) },
            onClear: { viewStore.send(.newPasswordConfirmTextClear) }
        )
    }
}
