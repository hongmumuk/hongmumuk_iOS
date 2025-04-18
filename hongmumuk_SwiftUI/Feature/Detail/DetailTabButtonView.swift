//
//  DetailTabButtonView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/22/25.
//

import ComposableArchitecture
import SwiftUI

struct DetailTabButtonView: View {
    @ObservedObject var viewStore: ViewStoreOf<DetailFeature>
    
    var body: some View {
        VStack(spacing: 0) {
            tabView
            tabLine
        }
        .padding(.horizontal, 24)
    }
    
    private var tabView: some View {
        HStack(spacing: 0) {
            tabButton(0, text: "map".localized())
            tabButton(1, text: "review".localized())
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
