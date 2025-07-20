//
//  ReviewMakeStarView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 7/7/25.
//

import SwiftUI

import ComposableArchitecture

struct ReviewMakeStarView: View {
    @ObservedObject var viewStore: ViewStoreOf<ReviewMakeFeature>

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0 ..< 5, id: \.self) { index in
                starButton(index: index, rating: viewStore.starRate)
            }
        }
        .padding(.top, 40)
    }
    
    private func starButton(index: Int, rating: Double) -> some View {
        Button(action: {
            viewStore.send(.starButtonTapped(index))
        }) {
            let current = Double(index)
            let imageName = rating >= current + 1 ? "star_full" : "star_empty"
            Image(imageName)
                .resizable()
                .frame(width: 40, height: 40)
        }
    }
}
