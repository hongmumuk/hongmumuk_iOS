//
//  ReivewMakePhotoView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 7/22/25.
//

import SwiftUI

import ComposableArchitecture

struct ReviewMakePhotoView: View {
    @ObservedObject var viewStore: ViewStoreOf<ReviewMakeFeature>
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 12) {
                ForEach(Array(viewStore.photos.enumerated()), id: \.offset) { index, image in
                    ZStack(alignment: .topTrailing) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 136, height: 136)
                            .clipped()
                            .cornerRadius(16)
                        
                        Button {
                            viewStore.send(.removePhoto(index))
                        } label: {
                            Image("smallClearIcon")
                                .padding(12)
                        }
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
        }
    }
}
