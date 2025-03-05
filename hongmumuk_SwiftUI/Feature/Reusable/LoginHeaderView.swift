//
//  LoginHeaderView.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 3/4/25.
//

import ComposableArchitecture
import SwiftUI

struct LoginHeaderView: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        VStack {
            header
                .frame(height: 56)
                .padding(.horizontal, 24)
                .overlay(bottomBorderLine, alignment: .bottom)
        }
    }
    
    private var bottomBorderLine: some View {
        Rectangle()
            .frame(height: 1)
            .foregroundColor(Colors.Border.neutral)
    }
    
    private var header: some View {
        ZStack {
            HStack(alignment: .center) {
                backButton
                
                Spacer()
            }
            
            HStack(alignment: .center) {
                Spacer()
                
                titleText
                
                Spacer()
            }
        }
    }
    
    private var backButton: some View {
        Button(action: {
            action()
        }) {
            Image("backIcon")
                .frame(width: 36, height: 36)
        }
    }
    
    private var titleText: some View {
        Text(title)
            .fontStyle(Fonts.heading1Bold)
            .foregroundStyle(Colors.GrayScale.normal)
    }
}
