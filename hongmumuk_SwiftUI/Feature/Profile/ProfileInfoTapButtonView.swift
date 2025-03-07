//
//  ProfileInfoTapButtonView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 3/7/25.
//

import SwiftUI

import ComposableArchitecture

struct ProfileInfoTapButtonView: View {
    @ObservedObject var viewStore: ViewStoreOf<ProfileInfoFeature>
    
    var body: some View {
        VStack(spacing: 0) {
            tabView
            tabLine
        }
        .padding(.horizontal, 24)
    }
    
    private var tabView: some View {
        HStack(spacing: 0) {
            tabButton(0, text: "회원정보 수정")
            tabButton(1, text: "비밀번호 변경")
        }
    }
    
    private func tabButton(_ index: Int, text: String) -> some View {
        Button(action: {
            viewStore.send(.pickerSelectionChanged(index), animation: .default)
        }) {
            Spacer()
            Text(text)
                .fontStyle(Fonts.heading2Bold)
                .foregroundColor(viewStore.state.pickerSelection == index ? Colors.Primary.normal : Colors.GrayScale.grayscale30)
                .padding(.vertical, 12.5)
            Spacer()
        }
    }
    
    private var tabLine: some View {
        GeometryReader { geometry in
            let tabWidth = geometry.size.width / 2
            Rectangle()
                .fill(Colors.Primary.normal)
                .frame(width: tabWidth, height: 1)
                .offset(x: viewStore.state.pickerSelection == 0 ? 0 : tabWidth)
                .animation(.easeInOut, value: viewStore.state.pickerSelection)
        }
        .frame(height: 1)
    }
}
