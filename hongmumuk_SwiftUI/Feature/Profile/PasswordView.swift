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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            currentPasswordTitle
            currentPasswordTextFieldStack
            
            Spacer()
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
            placeholder: "현재 비밀번호를 입력해 주세요",
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
}
