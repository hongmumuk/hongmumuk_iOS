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
    @ObservedObject var parentViewStore: ViewStoreOf<RootFeature>
    @FocusState private var isNickNameFocused: Bool
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if viewStore.showToast {
                ToastView(
                    imageName: "checkWhiteIcon",
                    title: "nickname_updated".localized()
                )
                .padding(.bottom, 144)
            }
            
            VStack(alignment: .leading, spacing: 0) {
                nickNameTitle
                nickNameTextFieldStack
                emailTitle
                emailTextFieldStack
                Spacer()
                buttonStack
            }
        }
        .alert("confirm_logout".localized(), isPresented: viewStore.binding(
            get: \.showLogoutAlert,
            send: .alertDismiss
        ),
        actions: {
            Button("cancel".localized(), role: .none) {}
            
            Button("confirm".localized(), role: .none) {
                viewStore.send(.logoutConfirmButtonTapped)
            }
        }, message: {
            Text("can_relogin_anytime".localized())
        })
        .alert("confirm_withdrawal".localized(), isPresented: viewStore.binding(
            get: \.showWithdrawAlert,
            send: .alertDismiss
        ),
        actions: {
            Button("cancel".localized(), role: .none) {}
            
            Button("confirm".localized(), role: .none) {
                viewStore.send(.withdrawConfirmButtonTapped)
            }
        }, message: {
            Text("withdrawal_data_warning".localized())
        })
        .onChange(of: viewStore.pop) { _, _ in
            parentViewStore.send(.onDismiss)
        }
    }
    
    private var nickNameTitle: some View {
        Text("nickname".localized())
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
            title: "edit".localized(),
            isActive: viewStore.nickNameState == .nicknameVerified
        ) {
            viewStore.send(.changeButtonTapped)
        }
        .frame(width: 104, height: 48)
        .cornerRadius(12)
    }
    
    private var emailTitle: some View {
        Text("email".localized())
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
            
            Text("\(viewStore.todayString)" + "verification_complete".localized())
                .fontStyle(Fonts.caption1Medium)
                .foregroundStyle(Colors.GrayScale.grayscal45)
            
            Image("verificationIcon")
                .resizable()
                .frame(width: 12, height: 12)
        }
    }
    
    private var buttonStack: some View {
        ZStack {
            HStack(alignment: .center, spacing: 0) {
                Spacer()
                GrayPlainButton(title: "logout".localized()) {
                    viewStore.send(.logoutButtonTapped)
                }
                GrayPlainButton(title: "delete_account".localized()) {
                    viewStore.send(.withdrawButtonTapped)
                }
                Spacer()
            }
            
            verticalDivider
        }
        .padding(.bottom, 40)
    }
    
    private var verticalDivider: some View {
        Rectangle()
            .fill(Colors.GrayScale.grayscal45)
            .frame(width: 1, height: 12)
    }
    

}
