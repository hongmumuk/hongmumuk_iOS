//
//  DetailInfoView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/22/25.
//

import ComposableArchitecture
import SwiftUI

struct DetailInfoView: View {
    @ObservedObject var viewStore: ViewStoreOf<DetailFeature>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            titleArea
            if !viewStore.keywords.isEmpty {
                keywordItem
            }
        }
        .padding(.horizontal, 24)
    }
    
    private var titleArea: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 12) {
                detailTitle
                address
            }
            
            Spacer()
            
            if viewStore.isUser {
                likeButton
            }
        }
    }
    
    private var detailTitle: some View {
        HStack(spacing: 8) {
            Text(viewStore.restaurantDetail.name)
                .fontStyle(Fonts.title2Bold)
                .foregroundColor(Colors.GrayScale.grayscale95)
            
            Text(viewStore.restaurantDetail.category)
                .fontStyle(Fonts.heading3Bold)
                .foregroundColor(Colors.GrayScale.grayscal45)
        }
        .padding(.top, 42)
    }
    
    private var likeButton: some View {
        VStack(spacing: 0) {
            Button(action: {
                viewStore.send(.likeButtonTapped)
            }) {
                Image(viewStore.restaurantDetail.hasLiked ? "likeFilledIcon" : "likeIcon")
                    .resizable()
                    .frame(width: 28, height: 28)
            }
            
            Text("\(viewStore.restaurantDetail.likes)")
                .fontStyle(Fonts.body2Medium)
                .foregroundColor(Colors.GrayScale.grayscal45)
        }
        .frame(width: 28, height: 46)
        .padding(.top, 42)
    }
    
    private var address: some View {
        HStack(spacing: 4) {
            Image("distanceIcon")
                .frame(width: 20, height: 20)
            
            Text(viewStore.restaurantDetail.address)
                .fontStyle(Fonts.body1Medium)
                .foregroundColor(Colors.GrayScale.grayscale55)
            
            Button(action: {
                viewStore.send(.copyAddressButtonTapped)
            }) {
                Text("copy".localized())
                    .fontStyle(Fonts.body1Medium)
                    .foregroundColor(Colors.Primary.primary55)
            }
            
            Spacer()
        }
    }
    
    private var keywordItem: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(viewStore.keywords,
                        id: \.self)
                { searchText in
                    HStack(spacing: 4) {
                        Text(searchText)
                            .fontStyle(Fonts.body1Medium)
                            .foregroundColor(Colors.GrayScale.grayscale70)
                            .padding(.vertical, 6)
                    }
                    .padding(.horizontal, 12)
                    .background(itemBackgroundView)
                }
            }
            .padding(.horizontal, 2)
            .padding(.vertical, 2)
        }
    }
    
    private var itemBackgroundView: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Colors.GrayScale.grayscale5)
            .stroke(Colors.Border.normal)
    }
}
