//
//  ProfileHeaderView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 3/6/25.
//

import SwiftUI

import ComposableArchitecture

struct ProfileHeaderView: View {
    @ObservedObject var viewStore: ViewStoreOf<ProfileFeature>
    
    var body: some View {
        VStack {
            header
                .frame(height: 56)
                .padding(.horizontal, 24)
                .overlay(alignment: .bottom, content: {
                    bottomBorderLine
                })
        }
    }
    
    private var bottomBorderLine: some View {
        Rectangle()
            .frame(height: 1)
            .foregroundColor(Colors.Border.neutral)
    }
    
    private var header: some View {
        HStack(spacing: 0) {
            likeText
            Spacer()
        }
    }
    
    private var likeText: some View {
        Text("my_page".localized())
            .fontStyle(Fonts.title2Bold)
            .foregroundColor(Colors.GrayScale.grayscale95)
    }
}
