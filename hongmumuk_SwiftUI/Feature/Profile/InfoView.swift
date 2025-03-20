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
                copyToast
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
        .alert("로그아웃하시겠습니까?", isPresented: viewStore.binding(
            get: \.showLogoutAlert,
            send: .alertDismiss
        ),
        actions: {
            Button("취소", role: .none) {}
            
            Button("확인", role: .none) {
                viewStore.send(.logoutConfirmButtonTapped)
            }
        }, message: {
            Text("로그아웃 후에도 언제든 다시 로그인\n할 수 있습니다.")
        })
        .alert("정말 탈퇴하시겠습니까?", isPresented: viewStore.binding(
            get: \.showWithdrawAlert,
            send: .alertDismiss
        ),
        actions: {
            Button("취소", role: .none) {}
            
            Button("확인", role: .none) {
                viewStore.send(.withdrawConfirmButtonTapped)
            }
        }, message: {
            Text("탈퇴 시 계정 및 모든 데이터가 삭제되며\n복구되지 않습니다.")
        })
        .onChange(of: viewStore.pop) { _, _ in
            parentViewStore.send(.onDismiss)
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
    
    private var buttonStack: some View {
        ZStack {
            HStack(alignment: .center, spacing: 0) {
                Spacer()
                GrayPlainButton(title: "로그아웃") {
                    viewStore.send(.logoutButtonTapped)
                }
                GrayPlainButton(title: "회원탈퇴") {
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
    
    private var copyToast: some View {
        HStack(spacing: 10) {
            Image("CheckWhiteIcon")
                .resizable()
                .frame(width: 20, height: 20)
            
            Text("닉네임을 수정했어요")
                .fontStyle(Fonts.heading3Medium)
                .foregroundColor(.white)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.black.opacity(0.7))
        )
    }
}
