//
//  ReviewWriteButton.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 7/7/25.
//

import SwiftUI

import ComposableArchitecture

struct ReviewWriteButton: View {
    @ObservedObject var viewStore: ViewStoreOf<ReviewMakeFeature>

    var body: some View {
        GeometryReader { geometry in
            NextButton(
                title: "리뷰 작성하기",
                isActive: viewStore.isWriteActive,
                action: { viewStore.send(.writeButtonTapped) }
            )
            .frame(height: 60)
            .padding(.horizontal, 24)
            .padding(.top, 20)
            .padding(.bottom, geometry.size.height * 0.1)
        }
    }
}
