//
//  BasicButton.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 3/1/25.
//

import Foundation
import SwiftUI

struct BasicButton: View {
    let title: String
    let isActive: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(isActive ? Colors.Primary.normal : Colors.GrayScale.disable)
                
                Text(title)
                    .fontStyle(Fonts.body1Medium)
                    .foregroundColor(isActive ? .white : Colors.GrayScale.alternative)
            }
        }
        .disabled(!isActive)
        .buttonStyle(PlainButtonStyle())
    }
}
