//
//  InfoView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 3/7/25.
//

import SwiftUI

import ComposableArchitecture

struct InfoView: View {
    @ObservedObject var viewStore: ViewStoreOf<ProfileInfoFeature>
    @FocusState private var isNickNameFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            nickNameTitle
            nickNameTextFieldStack
            emailTitle
            emailTextFieldStack
            Spacer()
        }
    }
    
    private var nickNameTitle: some View {
        Text("닉네임")
            .fontStyle(Fonts.heading2Bold)
            .foregroundStyle(CommonTextFieldStyle.textColor(for: viewStore.nickNameState))
            .padding(.leading, 24)
            .padding(.top, 24)
    }
    
    private var nickNameTextFieldStack: some View {
        HStack(alignment: .top, spacing: 8) {
            nickNameTextField
            changeButton
        }
        .padding(.horizontal, 24)
        .padding(.top, 8)
    }
    
    private var nickNameTextField: some View {
        CommonTextFieldView(
            isFocused: $isNickNameFocused,
            text: viewStore.nickName,
            state: viewStore.nickNameState,
            message: viewStore.nickNameErrorMessage,
            placeholder: viewStore.profile.nickName,
            isSecure: false,
            onTextChanged: { viewStore.send(.nickNameChanged($0)) },
            onFocusedChanged: { viewStore.send(.nickNameFocused($0)) },
            onSubmit: { viewStore.send(.nickNameOnSubmit) },
            onClear: { viewStore.send(.nickNameTextClear) }
        )
    }
    
    private var changeButton: some View {
        BasicButton(
            title: "수정하기",
            isActive: viewStore.nickNameState == .nicknameVerified
        ) {
            viewStore.send(.changeButtonTapped)
        }
        .frame(width: 104, height: 48)
        .cornerRadius(12)
    }
    
    private var emailTitle: some View {
        Text("이메일")
            .fontStyle(Fonts.heading2Bold)
            .foregroundStyle(Colors.GrayScale.grayscale95)
            .padding(.leading, 24)
            .padding(.top, 24)
    }
    
    private var emailTextFieldStack: some View {
        VStack(spacing: 8) {
            emailTextField
            verificationTitle
        }
        .padding(.horizontal, 24)
        .padding(.top, 8)
    }
    
    private var emailTextField: some View {
        CommonTextFieldView(
            isFocused: $isNickNameFocused,
            text: viewStore.profile.email,
            state: .disabled,
            message: nil,
            placeholder: viewStore.profile.nickName,
            isSecure: false,
            onTextChanged: { _ in },
            onFocusedChanged: { _ in },
            onSubmit: {},
            onClear: {}
        )
    }
    
    private var verificationTitle: some View {
        HStack(spacing: 4) {
            Spacer()
            
            Text("\(viewStore.todayString) 인증 완료")
                .fontStyle(Fonts.caption1Medium)
                .foregroundStyle(Colors.GrayScale.grayscal45)
            
            Image("verificationIcon")
                .resizable()
                .frame(width: 12, height: 12)
        }
    }
}
