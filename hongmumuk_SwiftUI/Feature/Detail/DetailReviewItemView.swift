//
//  DetailReviewItemView.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 6/25/25.
//

import ComposableArchitecture
import Foundation
import SwiftUI

struct DetailReviewItemView: View {
    let item: Review
    let isLast: Bool
    let viewStore: ViewStoreOf<DetailFeature>

    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
                .frame(height: 24)
            
            reviewMetaView
            
            Spacer()
                .frame(height: 10)
            
            StarRatingView(rating: item.star)
            
            Spacer()
                .frame(height: 10)

            Text(item.content)
                .fontStyle(Fonts.body1SemiBold)
                .foregroundColor(Colors.GrayScale.normal)
            
            Spacer()
                .frame(height: 10)

            photoCarouselView
            
            Spacer()
                .frame(height: 24)
            
            if !isLast {
                Rectangle()
                    .frame(height: 1.5)
                    .foregroundColor(Colors.GrayScale.disable)
            }
        }
    }

    private var reviewMetaView: some View {
        HStack {
            Text(item.user)
                .fontStyle(Fonts.heading3Bold)
                .foregroundColor(Colors.GrayScale.grayscale95)

            Spacer()
                .frame(width: 4)
            
            Image("badge")
                .frame(width: 20, height: 20)
            
            Spacer()
                .frame(width: 16)
            
            Text(DateUtils.formattedReviewDate(from: item.date))
                .fontStyle(Fonts.body2SemiBold)
                .foregroundColor(Colors.GrayScale.alternative)
            
            Spacer()
                .frame(width: 6)
            
            Circle()
                .frame(width: 2, height: 2)
                .foregroundColor(Colors.GrayScale.alternative)
            
            Text("\(item.visitCount)번째 방문")
                .fontStyle(Fonts.body2SemiBold)
                .foregroundColor(Colors.GrayScale.alternative)
            
            Spacer()
            
            if item.isOwner {
                Menu {
                    Button("수정") {
                        viewStore.send(.reviewEditButtonTapped(item.id))
                    }
                    Button("삭제", role: .destructive) {
                        viewStore.send(.reviewDeleteButtonTapped(item.id))
                    }
                } label: {
                    Image("reviewModifyIcon")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
        }
    }
    
    private var photoCarouselView: some View {
        Group {
            if !item.photoURLs.isEmpty {
                GeometryReader { geometry in
                    let width = geometry.size.width
                    TabView {
                        ForEach(item.photoURLs, id: \.self) { url in
                            AsyncImage(url: URL(string: url)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: width, height: width)
                                    .clipped()
                            } placeholder: {
                                Color.gray.opacity(0.2)
                                    .frame(width: width, height: width)
                                    .clipped()
                            }
                        }
                    }
                    .frame(width: width, height: width)
                    .tabViewStyle(.page)
                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                }
                .frame(height: UIScreen.main.bounds.width - 48)
            }
        }
    }
}
