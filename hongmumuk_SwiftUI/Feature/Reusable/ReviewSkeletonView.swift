//
//  ReviewSkeletonView.swift
//  hongmumuk_SwiftUI
//
//  Created by Assistant on 8/7/25.
//

import SwiftUI

struct ReviewSkeletonView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack {
            // 일반 리뷰 아이템 1개
            reviewItemView
            
            Spacer()
                .frame(height: 24)
            
            Rectangle()
                .frame(height: 1.5)
                .foregroundColor(Colors.Label.Normal.disable)
                .padding(.horizontal, 24)
            
            Spacer()
                .frame(height: 24)
            
            // 포토 리뷰 아이템 1개
            photoReviewItemView
            
            Spacer()
                .frame(height: 24)
            
            Rectangle()
                .frame(height: 1.5)
                .foregroundColor(Colors.Label.Normal.disable)
                .padding(.horizontal, 24)
            
            Spacer()
                .frame(height: 24)
            
            // 일반 리뷰 아이템 1개
            reviewItemView
        }
        .opacity(isAnimating ? 0.6 : 1.0)
        .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isAnimating)
        .onAppear {
            isAnimating = true
        }
    }
    
    private var reviewItemView: some View {
        VStack(alignment: .leading, spacing: 12) {
            RoundedRectangle(cornerRadius: 6)
                .fill(Colors.Label.Normal.disable)
                .frame(height: 24)
            RoundedRectangle(cornerRadius: 6)
                .fill(Colors.Label.Normal.disable)
                .frame(width: 108, height: 24)
            RoundedRectangle(cornerRadius: 6)
                .fill(Colors.Label.Normal.disable)
                .frame(width: 108, height: 24)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 24)
    }
    
    // 포토리뷰: 리뷰 + 가로 스크롤 이미지(스켈레톤)
    private var photoReviewItemView: some View {
        VStack(alignment: .leading, spacing: 12) {
            reviewItemView
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(0..<3, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Colors.Label.Normal.disable)
                            .frame(width: 120, height: 120)
                    }
                }
                .padding(.leading, 24)
            }
        }
        .padding(.bottom, 12)
    }
}

