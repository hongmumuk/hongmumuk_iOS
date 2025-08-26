//
//  ReviewMakeTextView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 7/7/25.
//

import SwiftUI

import ComposableArchitecture

struct ReviewMakeTextView: View {
    @ObservedObject var viewStore: ViewStoreOf<ReviewMakeFeature>
    @FocusState private var isFocused: Bool
    @State private var text: String = ""
    
    var body: some View {
        ReviewEditorView(
            text: viewStore.binding(
                get: \.reviewText,
                send: ReviewMakeFeature.Action.textChanged
            ),
            isFocused: $isFocused,
            placeholder: "review_please_write".localized(),
            count: viewStore.textCount,
            onFocusedChanged: { isFocused in
                viewStore.send(.textFocusChanged(isFocused))
            },
            errorMessage: viewStore.errorMessage,
            status: viewStore.reviewTextStatus
        )
        .padding(.horizontal, 24)
        .padding(.top, 28)
    }
    
    enum TextStatus {
        case normal
        case error
    }
    
    struct ReviewEditorView: View {
        @Binding var text: String
        var isFocused: FocusState<Bool>.Binding
        var placeholder: String = "review_please_write".localized()
        var height: CGFloat = 120
        var count: Int
        var onFocusedChanged: (Bool) -> Void = { _ in }
        var onSubmit: () -> Void = {}
        var errorMessage = ""
        var status: TextStatus = .normal

        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text("review_title".localized())
                    .fontStyle(Fonts.heading3Bold)
                    .foregroundStyle(
                        status == .normal ? Colors.GrayScale.normal : Colors.SemanticColor.negative)

                ZStack(alignment: .topLeading) {
                    UnevenRoundedRectangle(
                        topLeadingRadius: 12,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: 12
                    )
                    .fill(
                        status == .normal ? Colors.GrayScale.grayscale5 : Colors.SemanticColor.negative10)
                    .frame(height: height)

                    Rectangle()
                        .fill(
                            status == .normal ? Colors.Border.strong : Colors.SemanticColor.negative)
                        .frame(height: 1)
                        .offset(y: height)

                    TextEditor(text: $text)
                        .padding(.all, 12)
                        .frame(height: height)
                        .focused(isFocused)
                        .font(Fonts.body1Medium.toFont())
                        .foregroundStyle(
                            status == .normal ? Colors.GrayScale.grayscale95 : Colors.SemanticColor.negative)
                        .scrollContentBackground(.hidden)
                        .background(.clear)
                        .onSubmit(onSubmit)
                        .onChange(of: isFocused.wrappedValue) { focused in
                            onFocusedChanged(focused)
                            if !focused { onSubmit() }
                        }

                    if text.isEmpty, !isFocused.wrappedValue {
                        Text(placeholder)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 20)
                            .fontStyle(Fonts.body1Medium)
                            .foregroundStyle(Colors.GrayScale.grayscale30)
                    }
                }
                
                HStack {
                    Text(errorMessage)
                        .fontStyle(Fonts.caption1Medium)
                        .foregroundStyle(
                            status == .normal ? Colors.GrayScale.alternative : Colors.SemanticColor.negative)
                    
                    Spacer()
                    
                    Text("\(count)/200")
                        .fontStyle(Fonts.caption1Medium)
                        .foregroundStyle(
                            status == .normal ? Colors.GrayScale.alternative : Colors.SemanticColor.negative)
                }
            }
        }
    }
}
