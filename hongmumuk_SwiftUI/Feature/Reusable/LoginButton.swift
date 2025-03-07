//
//  LoginButton.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 3/4/25.
//

import SwiftUI

struct LoginButton: View {
    let title: String
    let iconName: String
    let backgroundColor: Color
    let textColor: Color?
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Colors.Border.normal, lineWidth: 1)
                    )
                
                Text(title)
                    .fontStyle(Fonts.heading2Bold)
                    .foregroundColor(textColor)
                
                HStack {
                    Image(iconName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .padding(.leading, 20)
                    
                    Spacer()
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
