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
            detailTitle
            address
            if !viewStore.keywords.isEmpty {
                keywordItem
            }
        }
        .padding(.horizontal, 24)
    }
    
    private var detailTitle: some View {
        HStack(spacing: 8) {
            Text("발바리네")
                .fontStyle(Fonts.title2Bold)
                .foregroundColor(Colors.GrayScale.grayscale95)
            
            Text("한식")
                .fontStyle(Fonts.heading3Bold)
                .foregroundColor(Colors.GrayScale.grayscal45)
        }
        .padding(.top, 42)
    }
    
    private var address: some View {
        HStack(spacing: 4) {
            Image("distanceIcon")
                .frame(width: 20, height: 20)
            
            Text("서울 마포구 와우산로 51-6")
                .fontStyle(Fonts.body1Medium)
                .foregroundColor(Colors.GrayScale.grayscale55)
            
            Button(action: {
                viewStore.send(.copyAddressButtonTapped)
            }) {
                Text("복사")
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
        }
    }
    
    private var itemBackgroundView: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Colors.GrayScale.grayscale5)
            .stroke(Colors.Border.normal)
    }
}
