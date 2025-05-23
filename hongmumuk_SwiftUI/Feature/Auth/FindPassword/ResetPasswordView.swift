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
    let parentStore: StoreOf<RootFeature>
    
    @ObservedObject var viewStore: ViewStoreOf<ResetPasswordFeature>
    @ObservedObject var parentViewStore: ViewStoreOf<RootFeature>
    
    @FocusState private var isPasswordFocused: Bool
    @FocusState private var isVerifiedPasswordFocused: Bool
    
    init(store: StoreOf<ResetPasswordFeature>, parentStore: StoreOf<RootFeature>) {
        self.store = store
        self.parentStore = parentStore
        viewStore = ViewStore(store, observe: { $0 })
        parentViewStore = ViewStore(parentStore, observe: { $0 })
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    LoginHeaderView(title: "find_password".localized(), action: { parentViewStore.send(.onDismiss) })
                    
                    Spacer()
                }
                
                scrollView
                    .padding(.top, 56)
                
                VStack {
                    Spacer()
                    
                    NextButton(title: "비밀번호 재설정하기", isActive: viewStore.isResetPasswordButtonEnabled) {
                        if viewStore.isResetPasswordButtonEnabled {
                            viewStore.send(.continueButtonTapped)
                        }
                    }
                    .frame(height: 60)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 60)
                }
                .ignoresSafeArea(.keyboard)
            }
        }
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            isPasswordFocused = false
            isVerifiedPasswordFocused = false
        }
    }
    
    private var scrollView: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading) {
                    Text("password".localized())
                        .fontStyle(Fonts.heading2Bold)
                        .foregroundStyle(CommonTextFieldStyle.textColor(for: viewStore.passwordState))
                        .padding(.leading, 24)
                        .padding(.top, geometry.size.height * 0.056)
                    
                    CommonTextFieldView(
                        isFocused: $isPasswordFocused,
                        text: viewStore.password,
                        state: viewStore.passwordState,
                        message: viewStore.passwordErrorMessage,
                        placeholder: "enter_password_with_rules_2".localized(),
                        isSecure: !viewStore.passwordVisible,
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
                    
                    Text("confirm_password".localized())
                        .fontStyle(Fonts.heading2Bold)
                        .foregroundStyle(CommonTextFieldStyle.textColor(for: viewStore.verifiedPasswordState))
                        .padding(.leading, 24)
                        .padding(.top, 24)
                    
                    CommonTextFieldView(
                        isFocused: $isVerifiedPasswordFocused,
                        text: viewStore.verifiedPassword,
                        state: viewStore.verifiedPasswordState,
                        message: viewStore.verifiedPasswordMessage,
                        placeholder: "reenter_password".localized(),
                        isSecure: !viewStore.verifiedPasswordVisible,
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
                }
            }
        }
    }
}
