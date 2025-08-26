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
        NextButton(
            title: "review_write_cta".localized(),
            isActive: viewStore.isWriteActive,
            action: { viewStore.send(.writeButtonTapped) }
        )
        .frame(height: 60)
        .padding(.horizontal, 24)
        .padding(.bottom, 60)
    }
}
