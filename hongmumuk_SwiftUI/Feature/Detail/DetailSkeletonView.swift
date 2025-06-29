//
//  DetailSkeletonView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 3/6/25.
//

import SwiftUI

import ComposableArchitecture
import Shimmer

struct DetailSkeletonView: View {
    @SwiftUI.Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DetailPopButton { dismiss() }
            
            RoundedRectangle(cornerRadius: 8)
                .fill(Colors.GrayScale.grayscale10)
                .frame(height: 31)
                .padding(.top, 53)
            
            RoundedRectangle(cornerRadius: 8)
                .fill(Colors.GrayScale.grayscale10)
                .frame(height: 21)
                
            // 아래쪽 짧은 직사각형들
            HStack(spacing: 16) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Colors.GrayScale.grayscale10)
                    .frame(width: 96, height: 32)
                
                RoundedRectangle(cornerRadius: 16)
                    .fill(Colors.GrayScale.grayscale10)
                    .frame(width: 96, height: 32)
                
                Spacer()
            }
            
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .shimmering(active: true)
    }
}
