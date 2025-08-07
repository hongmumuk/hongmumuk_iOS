//
//  DetailReviewItemView.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 6/25/25.
//

import ComposableArchitecture
import Foundation
import SwiftUI

struct DetailReviewItemView: View {
    let item: Review
    let isLast: Bool
    @ObservedObject var viewStore: ViewStoreOf<DetailFeature>
    
    var body: some View {
        VStack{
            Spacer()
                .frame(height: 24)
            
            ReviewItemView<DetailFeature>(
                item: item,
                isLast: isLast,
                showDeleteButton: true,
                showBadge: true,
                activeToolTipReviewID: viewStore.activeToolTipReviewID,
                onDeleteTapped: { reviewId in
                    viewStore.send(.reviewDeleteButtonTapped(reviewId))
                },
                onToolTipToggled: { reviewId in
                    if viewStore.activeToolTipReviewID == reviewId {
                        viewStore.send(.hideToolTip)
                    } else {
                        viewStore.send(.showToolTip(id: reviewId))
                    }
                }
            )
        }
    }
}
