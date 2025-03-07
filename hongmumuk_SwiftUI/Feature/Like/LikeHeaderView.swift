//
//  LikeHeaderView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/18/25.
//

import ComposableArchitecture
import SwiftUI

struct LikeHeaderView: View {
    @ObservedObject var viewStore: ViewStoreOf<LikeFeature>
    
    var body: some View {
        VStack {
            header
                .frame(height: 56)
                .padding(.horizontal, 24)
                .overlay(alignment: .bottom, content: {
                    Group {
                        if viewStore.sortedRestaurantList.isEmpty {
                            bottomBorderLine
                        }
                    }
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
        Text("찜")
            .fontStyle(Fonts.title2Bold)
            .foregroundColor(Colors.GrayScale.grayscale95)
    }
}
