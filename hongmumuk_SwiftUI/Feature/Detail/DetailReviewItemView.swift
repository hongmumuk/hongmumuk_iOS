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
    @ObservedObject var viewStore: ViewStoreOf<DetailFeature>
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
                .frame(height: 24)
            
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

    private var badgeView: some View {
        Group {
            if let badge = item.badge {
                VStack(alignment: .leading, spacing: 10) {
                    Button(action: {
                        if viewStore.activeToolTipReviewID == item.id {
                            viewStore.send(.hideToolTip)
                        } else {
                            viewStore.send(.showToolTip(id: item.id))
                        }
                    }) {
                        HStack(spacing: 4) {
                            Image(badge.ableIconName)
                                .resizable()
                                .frame(width: 14, height: 14)

                            Text(badge.displayName)
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
                        if viewStore.activeToolTipReviewID == item.id {
                            VStack(spacing: 0) {
                                // 메인 툴팁 콘텐츠
                                VStack(alignment: .leading, spacing: 0) {
                                    Spacer()
                                        .frame(height: 12)
                                    
                                    Text("현재 \(badge.displayName) 단계의 리뷰예요")
                                        .fontStyle(Fonts.caption1Semibold)
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                        .frame(height: 8)
                                    
                                    badgeRowView(currentBadge: badge)
                                    
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

    public func badgeRowView(currentBadge: Badge?) -> some View {
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

struct BadgePositionPreferenceKey: PreferenceKey {
    static var defaultValue: [Int: Anchor<CGRect>] = [:]
    static func reduce(value: inout [Int: Anchor<CGRect>], nextValue: () -> [Int: Anchor<CGRect>]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}
