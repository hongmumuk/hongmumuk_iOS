//
//  EmailTextFieldView.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 2/28/25.
//

import ComposableArchitecture
import SwiftUI

struct EmailTextFieldView: View {
    var isEmailFocused: FocusState<Bool>.Binding
    @ObservedObject var viewStore: ViewStoreOf<EmailLoginFeature>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            emailTextField
            
            if let emailError = viewStore.emailErrorMessage {
                Text(emailError)
                    .fontStyle(Fonts.caption1Medium)
                    .foregroundStyle(Colors.SemanticColor.negative)
            }
        }
    }
    
    private var emailTextField: some View {
        HStack(alignment: .top) {
            emailPrefixTextFieldView
            
            emailAtSymbolView
                .padding(.leading, 8)
            
            emailSuffixTextFieldView
                .padding(.leading, 8)
                .fixedSize(horizontal: true, vertical: false)
        }
    }
    
    // MARK: - emailPrefix

    private var emailPrefixTextFieldView: some View {
        ZStack {
            emailTextFieldBackgroundView
            emailTextFieldBorderView
                .padding(.top, 47)
            
            HStack {
                emailPrefixTextField
                    .padding(.leading, 12)
                
                if !viewStore.email.isEmpty, isEmailFocused.wrappedValue {
                    emailTextFieldClearButton
                        .padding(.trailing, 12)
                }
            }
        }
    }
    
    private var emailTextFieldBackgroundView: some View {
        UnevenRoundedRectangle(topLeadingRadius: 12, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 12)
            .fill(CommonTextFieldStyle.backgroundColor(for: viewStore.emailState))
            .frame(height: 47)
    }
    
    private var emailTextFieldBorderView: some View {
        Divider()
            .background(CommonTextFieldStyle.borderColor(for: viewStore.emailState))
            .frame(height: 1)
    }
    
    private var emailPrefixTextField: some View {
        TextField("학교 이메일을 입력해 주세요", text: Binding(
            get: { viewStore.email },
            set: { viewStore.send(.emailChanged($0)) }
        ))
        .focused(isEmailFocused)
        .onSubmit { viewStore.send(.emailOnSubmit) }
        .onChange(of: isEmailFocused.wrappedValue) { isFocused in
            viewStore.send(.emailFocused(isFocused))
            
            if !isFocused {
                viewStore.send(.emailOnSubmit)
            }
        }
        .font(Fonts.body1Medium.toFont())
        .foregroundColor(CommonTextFieldStyle.textColor(for: viewStore.emailState))
    }
    
    private var emailTextFieldClearButton: some View {
        Button(action: { viewStore.send(.emailTextClear) }) {
            Image("TextFieldClearIcon")
                .frame(width: 20, height: 20)
        }
    }
    
    // MARK: - emailAtSymbol

    private var emailAtSymbolView: some View {
        Text("@")
            .fontStyle(Fonts.heading3Medium)
            .foregroundStyle(Colors.GrayScale.normal)
            .frame(minHeight: 48)
    }
    
    // MARK: - emailSuffix

    private var emailSuffixTextFieldView: some View {
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
                .padding(.leading, 12)
                .padding(.trailing, 9)
        }
    }
}
