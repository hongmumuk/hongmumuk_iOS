//
//  ReviewMakeView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 7/7/25.
//

import SwiftUI

import ComposableArchitecture

struct ReviewMakeView: View {
    private let store: StoreOf<ReviewMakeFeature>
    @ObservedObject var viewStore: ViewStoreOf<ReviewMakeFeature>
    
    init(store: StoreOf<ReviewMakeFeature>) {
        self.store = store
        viewStore = ViewStore(store, observe: { $0 })
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ReviewMakeHeaderView(viewStore: viewStore)
            ReviewMakeStarView(viewStore: viewStore)
            ReviewMakeTextView(viewStore: viewStore)
            ReviewMakePhotoAddView(viewStore: viewStore)
            Spacer()
            ReviewMakeNoticeView(viewStore: viewStore)
            ReviewWriteButton(viewStore: viewStore)
        }
        .sheet(isPresented: viewStore.binding(
            get: \.isShowingPhotoPicker,
            send: .dismissSheet
        )
        ) {
            PhotoPickerView(
                limit: 5 - viewStore.photoCount
            ) { images in
                viewStore.send(.photoPickerFinished(images))
            }
        }
        .fullScreenCover(isPresented: viewStore.binding(
            get: \.isShowingCamera,
            send: .dismissSheet
        )
        ) {
            CameraView { image in
                if let image { viewStore.send(.cameraShot(image)) }
            }
        }
    }
}
