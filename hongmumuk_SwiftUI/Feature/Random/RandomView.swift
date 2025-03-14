//
//  RandomView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/25/25.
//

import ComposableArchitecture
import SwiftUI

struct RandomView: View {
    private let store: StoreOf<RandomFeature>
    @ObservedObject var viewStore: ViewStoreOf<RandomFeature>
    
    init(store: StoreOf<RandomFeature>) {
        self.store = store
        viewStore = ViewStore(store, observe: { $0 })
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                title
                Spacer()
            }
            
            if viewStore.isAnimating {
                RandomAnimationView(viewStore: viewStore)
            } else {
                VStack(spacing: 20) {
                    image
                    restaurantInfo
                }
            }

            VStack {
                Spacer()
                retryButton
            }
        }
        .onAppear {
            viewStore.send(.onAppear)
        }
    }
    
    var title: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewStore.title)
                .fontStyle(Fonts.title2Bold)
                .foregroundColor(Colors.GrayScale.grayscale95)
            
            Text(viewStore.subTitle)
                .fontStyle(Fonts.heading3Medium)
                .foregroundColor(Colors.GrayScale.grayscal45)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 80)
        .padding(.horizontal, 24)
    }
    
    var image: some View {
        Image("thumbnailBigIcon")
            .resizable()
            .cornerRadius(24)
            .frame(width: 240, height: 240)
    }
    
    var restaurantInfo: some View {
        VStack(alignment: .center, spacing: 4) {
            Text(viewStore.restaurantName)
                .fontStyle(Fonts.heading2Bold)
                .foregroundColor(Colors.GrayScale.grayscale95)
            
            Text(viewStore.restaurantCategory)
                .fontStyle(Fonts.body2SemiBold)
                .foregroundColor(Colors.GrayScale.grayscal45)
        }
    }
    
    var retryButton: some View {
        Button(action: {
            viewStore.send(.randomButtonTapped, animation: .default)
        }) {
            Text(viewStore.buttonTitle)
                .fontStyle(Fonts.heading2Bold)
                .foregroundColor(Color.white)
                .frame(height: 60)
                .frame(maxWidth: .infinity)
        }
        .background(Colors.Primary.primary55)
        .cornerRadius(20)
        .padding(.horizontal, 24)
        .padding(.bottom, 60)
    }
}
