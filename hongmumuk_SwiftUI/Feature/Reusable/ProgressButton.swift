//
//  ProgressButton.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 2/14/25.
//

import SwiftUI

struct ProgressButton: View {
    let number: String
    let isActive: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(isActive ? Colors.Primary.normal : Colors.GrayScale.disable)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Colors.Border.normal, lineWidth: 1)
                )
            
            Text(number)
                .fontStyle(Fonts.body1SemiBold)
                .foregroundColor(isActive ? .white : Colors.GrayScale.alternative)
        }
    }
}
