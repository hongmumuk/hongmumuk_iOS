//
//  DetailReviewView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/22/25.
//

import ComposableArchitecture
import SwiftUI

struct DetailReviewView: View {
    @ObservedObject var viewStore: ViewStoreOf<DetailFeature>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 목록
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    sourceTextView
                    
                    ForEach(viewStore.restaurantDetail.blogs) { item in
                        DetailReviewItemView(item: item)
                            .padding(.horizontal, 24)
                            .padding(.bottom, 12)
                            .onTapGesture { viewStore.send(.reviewTapped(item.url)) }
                    }
                }
            }
        }
    }
    
    private var sourceTextView: some View {
        HStack {
            Text("출처")
                .fontStyle(Fonts.body1SemiBold)
                .foregroundColor(Colors.GrayScale.grayscal45)
            
            Rectangle()
                .fill(Colors.GrayScale.grayscal45)
                .frame(width: 1, height: 12)
                .cornerRadius(0.5)
            
            Image("naverIcon")
                .frame(width: 16, height: 16)
            
            Text("네이버 블로그 검색 기반 결과입니다")
                .fontStyle(Fonts.body1SemiBold)
                .foregroundColor(Colors.GrayScale.grayscal45)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
    }
}

struct DetailReviewItemView: View {
    let item: Blog
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(item.title)
                .fontStyle(Fonts.heading3Bold)
                .foregroundColor(Colors.GrayScale.grayscale95)
            
            Text(item.subtitle)
                .fontStyle(Fonts.body2Medium)
                .foregroundColor(Colors.GrayScale.grayscal45)
                .lineLimit(2)
            
            HStack {
                Spacer()
                Text("\(item.owner) . \(item.date)")
                    .fontStyle(Fonts.caption1Medium)
                    .foregroundColor(Colors.GrayScale.grayscale30)
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 12)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Colors.Border.normal, lineWidth: 1)
        )
    }
}
