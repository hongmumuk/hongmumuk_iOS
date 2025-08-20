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
    private let parentStore: StoreOf<RootFeature>
    @ObservedObject var viewStore: ViewStoreOf<RandomFeature>
    @ObservedObject var parentViewStore: ViewStoreOf<RootFeature>
    
    init(store: StoreOf<RandomFeature>, parentStore: StoreOf<RootFeature>) {
        self.store = store
        self.parentStore = parentStore
        viewStore = ViewStore(store, observe: { $0 })
        parentViewStore = ViewStore(parentStore, observe: { $0 })
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
                detailButton
            }

            VStack {
                Spacer()
                retryButton
            }
        }
        .onAppear {
            viewStore.send(.onAppear)
        }
        .fullScreenCover(
            isPresented: viewStore.binding(
                get: { $0.activeScreen != .none },
                send: .onDismiss
            )
        ) {
            if case let .restaurantDetail(id) = viewStore.activeScreen {
                DetailView(
                    store: Store(
                        initialState: DetailFeature.State(id: id),
                        reducer: { DetailFeature() },
                        withDependencies: {
                            $0.restaurantClient = RestaurantClient.liveValue
                            $0.keywordClient = KeywordClient.liveValue
                        }
                    ),
                    parentStore: parentStore
                )
                .presentationDragIndicator(.visible)
            }
        }
    }
    
    var detailButton: some View {
        Button {
            viewStore.send(.detailButtonTapped)
        } label: {
            VStack(spacing: 20) {
                image
                restaurantInfo
            }
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
        OptimizedAsyncImage(url: URL(string: viewStore.restaurantImageUrl),
                            targetSize: .init(width: 500, height: 500))
        { image in
            image
                .resizable()
                .scaledToFill()
                .frame(width: 240, height: 240)
        } placeholder: {
            ZStack {
                Color.clear
                    .frame(width: 240, height: 240)
                
                Image(viewStore.restaurantCategory.rawValue)
                    .resizable()
                    .frame(width: 115, height: 115)
            }
        }
        .cornerRadius(24)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Colors.GrayScale.grayscale5)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .strokeBorder(Colors.Border.neutral, lineWidth: 1)
        )
        .frame(width: 240, height: 240)
        .id(viewStore.restaurantImageUrl)
    }
    
    var restaurantInfo: some View {
        VStack(alignment: .center, spacing: 4) {
            Text(viewStore.restaurantName)
                .fontStyle(Fonts.heading2Bold)
                .foregroundColor(Colors.GrayScale.grayscale95)
            
            Text(viewStore.restaurantCategoryName)
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
