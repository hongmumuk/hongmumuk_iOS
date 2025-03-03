//
//  SignupToastView.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 3/2/25.
//

import SwiftUI

struct SignupToastView: View {
    var imageName: String
    var title: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(Colors.GrayScale.normal.opacity(0.7))
                .frame(height: 44)
            
            HStack(alignment: .center) {
                Image(imageName)
                    .frame(width: 20, height: 20)
                
                Spacer()
                
                Text(title)
                    .foregroundStyle(Colors.SemanticColor.positive0)
                    .fontStyle(Fonts.heading3Medium)
            }
            .padding(.horizontal, 16)
        }
    }
}
