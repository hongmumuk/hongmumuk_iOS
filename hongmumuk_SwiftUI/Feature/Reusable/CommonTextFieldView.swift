//
//  CommonTextFieldView.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 3/2/25.
//

import ComposableArchitecture
import SwiftUI

struct CommonTextFieldView: View {
    var isFocused: FocusState<Bool>.Binding
    var text: String
    var state: TextFieldState
    var message: String?
    var placeholder: String
    var isSecure: Bool
    var showAtSymbol: Bool = false
    var showSuffix: Bool = false
    var suffixText: String? = nil
    var onTextChanged: (String) -> Void
    var onFocusedChanged: (Bool) -> Void
    var onSubmit: () -> Void
    var onClear: () -> Void
    var onToggleVisibility: (() -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            textFieldView
                .disabled(state == .disabled || state == .codeVerified)
            
            if let message {
                messageView(message, massegeColor: CommonTextFieldStyle.massegeColor(for: state))
            }
        }
    }
    
    private var textFieldView: some View {
        HStack(alignment: .top) {
            ZStack {
                backgroundView
                borderView
                    .padding(.top, 47)
                
                HStack {
                    if isSecure {
                        SecureField(placeholder, text: Binding(get: { text }, set: onTextChanged))
                    } else {
                        TextField(placeholder, text: Binding(get: { text }, set: onTextChanged))
                    }
                    
                    if !text.isEmpty, isFocused.wrappedValue, let onToggleVisibility {
                        visibilityToggleButton(action: onToggleVisibility)
                            .padding(.trailing, 6)
                    }
                    
                    if !text.isEmpty, isFocused.wrappedValue {
                        clearButton
                            .padding(.trailing, 12)
                    }
                }
                .padding(.leading, 12)
                .focused(isFocused)
                .onSubmit(onSubmit)
                .onChange(of: isFocused.wrappedValue) { isFocused in
                    onFocusedChanged(isFocused)
                    if !isFocused {
                        onSubmit()
                    }
                }
                .font(Fonts.body1Medium.toFont())
                .foregroundColor(CommonTextFieldStyle.textColor(for: state))
            }
            
            if showAtSymbol {
                atSymbolView
                    .padding(.leading, 8)
            }
            
            if showSuffix, let suffixText {
                suffixTextView(suffixText)
                    .padding(.leading, 8)
                    .fixedSize(horizontal: true, vertical: false)
            }
        }
    }
    
    private var backgroundView: some View {
        UnevenRoundedRectangle(topLeadingRadius: 12, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 12)
            .fill(CommonTextFieldStyle.backgroundColor(for: state))
            .frame(height: 47)
    }
    
    private var borderView: some View {
        Divider()
            .background(CommonTextFieldStyle.borderColor(for: state))
            .frame(height: 1)
    }
    
    private var clearButton: some View {
        Button(action: onClear) {
            Image("TextFieldClearIcon")
                .frame(width: 20, height: 20)
        }
    }
    
    private func visibilityToggleButton(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(isSecure ? "TextFieldInvisibleIcon" : "TextFieldVisibleIcon")
                .frame(width: 20, height: 20)
        }
    }
    
    private var atSymbolView: some View {
        Text("@")
            .fontStyle(Fonts.heading3Medium)
            .foregroundStyle(Colors.GrayScale.normal)
            .frame(minHeight: 48)
    }
    
    private func suffixTextView(_ text: String) -> some View {
        ZStack {
            UnevenRoundedRectangle(topLeadingRadius: 12, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 12)
                .fill(Color(hex: "FAFBFE"))
                .frame(height: 47)
            
            Divider()
                .background(Colors.Border.strong)
                .frame(height: 1)
                .padding(.top, 47)
            
            Text(text)
                .fontStyle(Fonts.body1Medium)
                .foregroundStyle(Colors.GrayScale.normal)
                .padding(.leading, 12)
                .padding(.trailing, 9)
        }
    }
    
    private func messageView(_ message: String, massegeColor: Color) -> some View {
        return Text(message)
            .fontStyle(Fonts.caption1Medium)
            .foregroundStyle(massegeColor)
    }
}
