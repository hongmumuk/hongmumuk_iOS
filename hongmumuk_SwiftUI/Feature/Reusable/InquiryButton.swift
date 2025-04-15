//
//  InquiryButton.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/18/25.
//

import ComposableArchitecture
import SwiftUI

struct InquiryButton: View {
    let action: () -> Void
    let showText: Bool
    
    init(action: @escaping () -> Void, showText: Bool = true) {
        self.action = action
        self.showText = showText
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if showText {
                inquryText
            }
            inquryBoxButton
        }
    }
    
    private var inquryText: some View {
        Text("no_matching_restaurant".localized())
            .fontStyle(Fonts.heading3Medium)
            .foregroundColor(Colors.GrayScale.grayscal45)
            .padding(.bottom, 12)
    }
    
    private var inquryBoxButton: some View {
        Button(action: action) {
            inquryBox
        }
        .padding(.horizontal, 20)
        .frame(height: 72)
    }
    
    private var inquryBox: some View {
        HStack(spacing: 0) {
            Image("trumpetIcon")
                .frame(width: 24, height: 24)
                .padding(.trailing, 4)
            
            Text("식당 문의 (추가 등록, 폐점 신고)")
                .fontStyle(Fonts.heading3Bold)
                .foregroundColor(Colors.GrayScale.grayscale95)
            
            Spacer()
            
            Text("문의하기")
                .fontStyle(Fonts.body2SemiBold)
                .foregroundColor(Colors.Primary.primary55)
        }
        .frame(height: 72)
        .padding(.horizontal, 20)
        .background(backgroundView)
    }
    
    private var backgroundView: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Colors.GrayScale.grayscale5)
            .stroke(Colors.Border.normal)
    }
}
