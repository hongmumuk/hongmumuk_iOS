//
//  SignupPasswordView.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 3/2/25.
//

import ComposableArchitecture
import SwiftUI

struct SignupPasswordView: View {
    let store: StoreOf<SignupPasswordFeature>
    let parentStore: StoreOf<RootFeature>
    
    @ObservedObject var viewStore: ViewStoreOf<SignupPasswordFeature>
    @ObservedObject var parentViewStore: ViewStoreOf<RootFeature>
    
    @FocusState private var isPasswordFocused: Bool
    @FocusState private var isVerifiedPasswordFocused: Bool
    
    init(store: StoreOf<SignupPasswordFeature>, parentStore: StoreOf<RootFeature>) {
        self.store = store
        self.parentStore = parentStore
        viewStore = ViewStore(store, observe: { $0 })
        parentViewStore = ViewStore(parentStore, observe: { $0 })
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    LoginHeaderView(title: "회원가입", action: { parentViewStore.send(.onDismiss) })
                    
                    Spacer()
                }
                
                scrollView
                    .padding(.top, 56)
                
                VStack {
                    Spacer()
                    
                    NextButton(title: "가입하기", isActive: viewStore.isContinueButtonEnabled) {
                        if viewStore.isContinueButtonEnabled {
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
                    SignupHeaderView(
                        activeStep: 3,
                        title: "비밀번호를 입력해 주세요",
                        subtitle: "다시 로그인할 때 비밀번호 입력이 필요합니다"
                    )
                    
                    Text("비밀번호")
                        .fontStyle(Fonts.heading2Bold)
                        .foregroundStyle(CommonTextFieldStyle.textColor(for: viewStore.passwordState))
                        .padding(.leading, 24)
                        .padding(.top, geometry.size.height * 0.056)
                    
                    CommonTextFieldView(
                        isFocused: $isPasswordFocused,
                        text: viewStore.password,
                        state: viewStore.passwordState,
                        message: viewStore.passwordErrorMessage,
                        placeholder: "영문, 숫자 포함 8~20자 이내로 입력해 주세요",
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
