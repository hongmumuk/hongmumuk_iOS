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
        
            VStack(spacing: 20) {
                image
                restaurantInfo
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
            Text("오늘은 이 메뉴 어때요?")
                .fontStyle(Fonts.title2Bold)
                .foregroundColor(Colors.GrayScale.grayscale95)
            
            Text("메뉴가 마음에 들지 않으면 다시 뽑아 보세요")
                .fontStyle(Fonts.heading3Medium)
                .foregroundColor(Colors.GrayScale.grayscal45)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 133)
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
            viewStore.send(.retryButtonTapped)
        }) {
            Text("다시 뽑기")
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
