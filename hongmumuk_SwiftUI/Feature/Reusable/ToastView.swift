//
//  ToastView.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 3/2/25.
//

import SwiftUI

struct ToastView: View {
    let imageName: String
    let title: String
    
    init(imageName: String, title: String) {
        self.imageName = imageName
        self.title = title
    }
    
    var body: some View {
        HStack(spacing: 10) {
            Image(imageName)
                .resizable()
                .frame(width: 20, height: 20)
            
            Text(title)
                .fontStyle(Fonts.heading3Medium)
                .foregroundColor(Colors.Common.color0)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
                Colors.Decorate.Dimmer.heavy
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
        )
    }
}

