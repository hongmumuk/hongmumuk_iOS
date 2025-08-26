//
//  ReviewMakeNoticeView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 7/7/25.
//

import ComposableArchitecture
import SwiftUI

struct ReviewMakeNoticeView: View {
    @ObservedObject var viewStore: ViewStoreOf<ReviewMakeFeature>

    var body: some View {
        VStack(alignment: .leading) {
            Button(action: { viewStore.send(.noticeButtonTapped) }) {
                Text("review_guidelines_title".localized())
                    .fontStyle(Fonts.body2Medium)
                    .foregroundStyle(Colors.GrayScale.grayscal45)
                    .underline()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 24)
        .padding(.bottom, 32)
    }
}
