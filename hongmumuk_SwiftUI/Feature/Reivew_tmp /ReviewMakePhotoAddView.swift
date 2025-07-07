//
//  ReviewMakePhotoAddView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 7/7/25.
//

import SwiftUI

import ComposableArchitecture

struct ReviewMakePhotoAddView: View {
    @ObservedObject var viewStore: ViewStoreOf<ReviewMakeFeature>
    
    var body: some View {
        Button(action: { viewStore.send(.addPhotoButtonTapped) }) {
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Colors.Primary.primary55, lineWidth: 1.5)
                    .frame(height: 48)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.clear)
                    )
                
                HStack(spacing: 6) {
                    Image("cameraIcon")
                        .resizable()
                        .frame(width: 20, height: 20)
                    
                    Text("사진 추가하기 (\(viewStore.photoCount)/5)")
                        .fontStyle(Fonts.body1Medium)
                        .foregroundStyle(Colors.Primary.primary55)
                }
            }
        }
        .buttonStyle(.plain)
        .padding(.top, 24)
        .padding(.horizontal, 12)
    }
}
