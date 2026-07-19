//
//  HMPopupRootView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 7/19/26.
//

import SwiftUI

struct HMPopupRootView: View {
    let props: HMPopupProps
    let items: [HMPopupItem]
    let onClose: () -> Void

    @State private var showCarousel: Bool = false

    var body: some View {
        ZStack {
            HMPopupCoverView(
                props: props,
                items: items,
                onClose: onClose,
                onTapPost: {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        showCarousel = true
                    }
                }
            )
            .opacity(showCarousel ? 0 : 1)

            if showCarousel {
                HMPopupCarouselView(items: items, onClose: onClose)
                    .transition(.opacity)
            }
        }
    }
}
