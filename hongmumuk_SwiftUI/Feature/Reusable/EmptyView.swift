//
//  EmptyView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/18/25.
//

import ComposableArchitecture
import SwiftUI

struct EmptyView: View {
    let type: Empty
    let action: (() -> Void)?

    init(type: Empty, action: (() -> Void)? = nil) {
        self.type = type
        self.action = action
    }
    
    var body: some View {
        switch type {
        case .search:
            searchEmpty
        case .like:
            emptyView
        case .likeUnAuth:
            emptyView
        }
    }
    
    var searchEmpty: some View {
        VStack {
            emptyView
                .padding(.top, 128)
            Spacer()
            if let action {
                InquiryButton(action: action)
                    .padding(.bottom, 60)
            }
        }
    }
    
    var emptyView: some View {
        VStack(spacing: 0) {
            Image("emptyIcon")
                .frame(width: 180, height: 180)
                .padding(.bottom, 12)
            
            Text(type.title)
                .fontStyle(Fonts.title2Bold)
                .foregroundColor(Colors.GrayScale.grayscale95)
                .padding(.bottom, 8)
            
            Text(type.subTitle)
                .fontStyle(Fonts.heading3Medium)
                .foregroundColor(Colors.GrayScale.grayscal45)
        }
    }
}
