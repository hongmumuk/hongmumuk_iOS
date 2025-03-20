//
//  WebViewHeader.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 3/6/25.
//

import ComposableArchitecture
import SwiftUI

struct WebViewHeader: View {
    let title: String
    @ObservedObject var parentViewStore: ViewStoreOf<RootFeature>
    
    var body: some View {
        VStack {
            header
                .frame(height: 60)
                .padding(.horizontal, 24)
                .overlay(alignment: .bottom, content: {
                    bottomBorderLine
                })
        }
    }
    
    private var header: some View {
        ZStack {
            backButton
            categoryText
        }
    }
    
    private var backButton: some View {
        HStack {
            Button(action: {
                parentViewStore.send(.onDismiss)
            }) {
                Image("backIcon")
                    .frame(width: 36, height: 36)
            }
            Spacer()
        }
    }
    
    private var categoryText: some View {
        Text(title)
            .fontStyle(Fonts.heading1Bold)
            .foregroundColor(Colors.GrayScale.grayscale95)
    }
    
    private var bottomBorderLine: some View {
        Rectangle()
            .frame(height: 1)
            .foregroundColor(Colors.Border.neutral)
    }
}
