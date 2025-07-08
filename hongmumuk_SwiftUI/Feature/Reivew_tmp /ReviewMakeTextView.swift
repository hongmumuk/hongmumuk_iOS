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
        ReviewEditorView(text: $text, isFocused: $isFocused, placeholder: "리뷰를 작성해 주세요")
            .padding(.horizontal, 24)
            .padding(.top, 28)
    }
    
    struct ReviewEditorView: View {
        @Binding var text: String
        var isFocused: FocusState<Bool>.Binding
        var placeholder: String = "리뷰를 작성해 주세요"
        var height: CGFloat = 120
        var onFocusedChanged: (Bool) -> Void = { _ in }
        var onSubmit: () -> Void = {}
        
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                // 1) 제목
                Text("리뷰")
                    .fontStyle(Fonts.heading3Bold)
                    .foregroundStyle(Colors.GrayScale.normal)
                
                // 2) 입력 영역
                ZStack(alignment: .topLeading) {
                    // 배경(상단만 라운드)
                    UnevenRoundedRectangle(
                        topLeadingRadius: 12,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: 12
                    )
                    .fill(Colors.GrayScale.grayscale5)
                    .frame(height: height)
                    
                    // 하단 구분선
                    Rectangle()
                        .fill(Colors.Border.strong)
                        .frame(height: 1)
                        .offset(y: height)
                    
                    // 실제 입력기
                    TextEditor(text: $text)
                        .padding(.all, 12)
                        .frame(height: height)
                        .focused(isFocused)
                        .font(Fonts.body1Medium.toFont())
                        .foregroundColor(Colors.GrayScale.grayscale95)
                        .scrollContentBackground(.hidden)
                        .background(.clear)
                        .onSubmit(onSubmit)
                        .onChange(of: isFocused.wrappedValue) { focused in
                            onFocusedChanged(focused)
                            if !focused { onSubmit() }
                        }
                    
                    // 플레이스홀더
                    if text.isEmpty, !isFocused.wrappedValue {
                        Text(placeholder)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 20)
                            .fontStyle(Fonts.body1Medium)
                            .foregroundStyle(Colors.GrayScale.grayscale30)
                    }
                }
                
                // 3) 안내 메시지
                Text("리뷰는 최소 20자 이상 입력해 주세요.")
                    .fontStyle(Fonts.caption1Medium)
                    .foregroundStyle(Colors.GrayScale.grayscal45)
            }
        }
    }
}
