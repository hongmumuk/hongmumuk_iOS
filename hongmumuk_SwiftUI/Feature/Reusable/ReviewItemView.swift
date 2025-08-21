//
//  ReviewItemView.swift
//  hongmumuk_SwiftUI
//
//  Created by Assistant on 8/7/25.
//

import ComposableArchitecture
import Foundation
import SwiftUI

struct ReviewItemView<Feature: Reducer>: View where Feature.Action: Equatable {
    let item: Review
    let isLast: Bool
    let onDeleteTapped: (Int) -> Void
    let onToolTipToggled: (Int) -> Void
    let activeToolTipReviewID: Int?
    let showDeleteButton: Bool
    let showBadge: Bool
    
    init(
        item: Review,
        isLast: Bool = false,
        showDeleteButton: Bool = true,
        showBadge: Bool = true,
        activeToolTipReviewID: Int? = nil,
        onDeleteTapped: @escaping (Int) -> Void,
        onToolTipToggled: @escaping (Int) -> Void
    ) {
        self.item = item
        self.isLast = isLast
        self.showDeleteButton = showDeleteButton
        self.showBadge = showBadge
        self.activeToolTipReviewID = activeToolTipReviewID
        self.onDeleteTapped = onDeleteTapped
        self.onToolTipToggled = onToolTipToggled
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            reviewMetaView
            
            Spacer()
                .frame(height: 10)
            
            badgeView
            
            StarRatingView(rating: Double(item.star))
            
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
                .frame(width: 16)
            
            Text(DateUtils.formattedReviewDate(from: item.date))
                .fontStyle(Fonts.body2SemiBold)
                .foregroundColor(Colors.GrayScale.alternative)
            
            Spacer()
            
            if showDeleteButton, item.isOwner {
                Menu {
                    Button("삭제", role: .destructive) {
                        onDeleteTapped(item.id)
                    }
                } label: {
                    Image("reviewModifyIcon")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
        }
    }
    
    private var badgeView: some View {
        Group {
            if showBadge, item.badge != nil {
                VStack(alignment: .leading, spacing: 10) {
                    Button(action: {
                        onToolTipToggled(item.id)
                    }) {
                        HStack(spacing: 4) {
                            Image(item.badge!.ableIconName)
                                .resizable()
                                .frame(width: 14, height: 14)
                            
                            Text(item.badge!.displayName)
                                .foregroundColor(Colors.Primary.normal)
                                .fontStyle(Fonts.body2SemiBold)
                        }
                        .frame(height: 32)
                        .padding(.horizontal, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Colors.Primary.alternative)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Colors.Border.normal, lineWidth: 1)
                                )
                        )
                    }
                    .overlay(alignment: .top) {
                        if activeToolTipReviewID == item.id {
                            VStack(spacing: 0) {
                                // 메인 툴팁 콘텐츠
                                VStack(alignment: .leading, spacing: 0) {
                                    Spacer()
                                        .frame(height: 12)
                                    
                                    Text("현재 \(item.badge!.displayName) 단계의 리뷰예요")
                                        .fontStyle(Fonts.caption1Semibold)
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                        .frame(height: 8)
                                    
                                    badgeRowView(currentBadge: item.badge)
                                    
                                    Spacer()
                                        .frame(height: 12)
                                }
                                .padding(.horizontal, 16)
                                .frame(width: 240, height: 80)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.black.opacity(0.75))
                                        .blur(radius: 0)
                                )
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.clear)
                                        .background(.thinMaterial)
                                        .blur(radius: 10)
                                )
                                
                                HStack {
                                    Triangle()
                                        .fill(Color.black.opacity(0.75))
                                        .frame(width: 16, height: 10)
                                        .rotationEffect(.degrees(180))
                                        .offset(x: 20, y: -2)
                                    
                                    Spacer()
                                }
                                .frame(width: 240)
                            }
                            .offset(x: 76, y: -96)
                            .transition(.scale.combined(with: .opacity))
                            .zIndex(1000)
                        }
                    }
                }
            }
        }
    }
    
    private var photoCarouselView: some View {
        Group {
            if !item.photoURLs.isEmpty {
                GeometryReader { geometry in
                    let width = geometry.size.width
                    let reversedURLs = item.photoURLs.reversed()
                    
                    TabView {
                        ForEach(reversedURLs, id: \.self) { urlString in
                            let url = URL(string: urlString)
                            let size = CGSize(width: 720, height: 720)
                            
                            OptimizedAsyncImage(url: url, targetSize: size) { image in
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
    
    private func badgeRowView(currentBadge: Badge?) -> some View {
        HStack(spacing: 16) {
            ForEach(Badge.allCases, id: \.self) { badge in
                let isMyBadge = currentBadge == badge
                
                VStack(spacing: 2) {
                    Image(isMyBadge ? badge.ableIconName : badge.disableIconName)
                        .resizable()
                        .frame(width: 20, height: 20)
                    
                    Spacer()
                        .frame(height: 2)
                    
                    Text(badge.displayName)
                        .fontStyle(Fonts.caption2)
                        .foregroundColor(.white)
                }
            }
        }
    }
}
