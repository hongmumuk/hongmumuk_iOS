//
//  NextButton.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 2/14/25.
//

import Foundation
import SwiftUI

struct NextButton: View {
    let title: String
    let isActive: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(isActive ? Colors.Primary.normal : Colors.GrayScale.disable)
                
                Text(title)
                    .fontStyle(Fonts.heading2Bold)
                    .foregroundColor(isActive ? .white : Colors.GrayScale.alternative)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
