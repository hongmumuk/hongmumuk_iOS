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
        case .networkError:
            networkError
        case .like, .likeUnAuth:
            likeEmpty
        }
    }
    
    var networkError: some View {
        VStack {
            Spacer()
            emptyView
            Spacer()
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
    
    var likeEmpty: some View {
        VStack(spacing: 0) {
            emptyView
            if let action {
                loginButton(action)
                    .padding(.top, 48)
            }
        }
    }
    
    var emptyView: some View {
        VStack(spacing: 0) {
            Image(type.iconName)
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
    
    private func loginButton(_ action: @escaping () -> Void) -> some View {
        Button(action: action) {
            ZStack {
                Text("login_with_email".localized())
                    .fontStyle(Fonts.heading2Bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                HStack {
                    Image("homeIcon")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding(.leading, 20)
                    Spacer()
                }
            }
            .frame(height: 60)
            .frame(maxWidth: .infinity)
            .background(Colors.Primary.primary55)
            .cornerRadius(20)
        }
        .padding(.horizontal, 24)
    }
}
