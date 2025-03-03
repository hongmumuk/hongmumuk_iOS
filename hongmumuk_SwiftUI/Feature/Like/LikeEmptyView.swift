//
//  LikeEmptyView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/18/25.
//

import ComposableArchitecture
import SwiftUI

struct LikeEmptyView: View {
    var body: some View {
        emptyView
    }
    
    var emptyView: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Colors.GrayScale.grayscale5)
                .stroke(Colors.GrayScale.grayscale5)
                .frame(width: 100, height: 100)
                .padding(.bottom, 60)
            
            Text("아직 찜한 가게가 없습니다")
                .fontStyle(Fonts.title2Bold)
                .foregroundColor(Colors.GrayScale.grayscale95)
                .padding(.bottom, 9)
            
            Text("좋아하는 가게에 찜을 누르고 한 번에 모아 보세요")
                .fontStyle(Fonts.heading3Medium)
                .foregroundColor(Colors.GrayScale.grayscal45)
        }
    }
}
