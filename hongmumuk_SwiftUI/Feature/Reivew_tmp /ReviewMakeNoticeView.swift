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
            Spacer()
            Button(action: { viewStore.send(.noticeButtonTapped) }) {
                Text("리뷰 작성 시 유의사항")
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
