//
//  ResetPasswordView.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 3/1/25.
//

import ComposableArchitecture
import SwiftUI

struct ResetPasswordView: View {
    let store: StoreOf<ResetPasswordFeature>

    @ObservedObject var viewStore: ViewStoreOf<ResetPasswordFeature>
    @FocusState private var isPasswordFocused: Bool
    @FocusState private var isVerifiedPasswordFocused: Bool

    init(store: StoreOf<ResetPasswordFeature>) {
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
                    
                    Text("비밀번호")
                        .fontStyle(Fonts.heading2Bold)
                        .foregroundStyle(CommonTextFieldStyle.textColor(for: viewStore.passwordState))
                        .padding(.leading, 24)
                        .padding(.top, geometry.size.height * 0.04)
                    
                    CommonTextFieldView(
                        isFocused: $isPasswordFocused,
                        text: viewStore.password,
                        state: viewStore.passwordState,
                        message: viewStore.passwordErrorMessage,
                        placeholder: "영문, 숫자 포함 8~20자 이내로 입력해 주세요",
                        isSecure: viewStore.passwordVisible,
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
                    
                    Text("비밀번호 확인")
                        .fontStyle(Fonts.heading2Bold)
                        .foregroundStyle(CommonTextFieldStyle.textColor(for: viewStore.verifiedPasswordState))
                        .padding(.leading, 24)
                        .padding(.top, 24)
                    
                    CommonTextFieldView(
                        isFocused: $isVerifiedPasswordFocused,
                        text: viewStore.verifiedPassword,
                        state: viewStore.verifiedPasswordState,
                        message: viewStore.verifiedPasswordMessage,
                        placeholder: "비밀번호를 한번 더 입력해 주세요",
                        isSecure: viewStore.verifiedPasswordVisible,
                        showAtSymbol: false,
                        showSuffix: false,
                        suffixText: "",
                        onTextChanged: { viewStore.send(.verifiedPasswordChanged($0)) },
                        onFocusedChanged: { viewStore.send(.verifiedPasswordFocused($0)) },
                        onSubmit: { viewStore.send(.verifiedPasswordOnSubmit) },
                        onClear: { viewStore.send(.verifiedPasswordTextClear) },
                        onToggleVisibility: { viewStore.send(.verifiedVisibleToggled) }
                    )
                    
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                    
                    Spacer()
                    
                    NextButton(title: "비밀번호 재설정하기", isActive: viewStore.isResetPasswordButtonEnabled) {
                        if viewStore.isResetPasswordButtonEnabled {
                            viewStore.send(.resetPasswordButtonTapped)
                        }
                    }
                    .frame(height: 60)
                    .padding(.horizontal, 24)
                    .padding(.bottom, geometry.size.height * 0.1)
                }
            }
            .navigationTitle("비밀번호 재설정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("비밀번호 재설정")
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
                isPasswordFocused = false
                isVerifiedPasswordFocused = false
            }
        }
    }
}
