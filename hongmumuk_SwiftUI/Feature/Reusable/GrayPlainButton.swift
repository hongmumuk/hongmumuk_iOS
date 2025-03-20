//
//  GrayPlainButton.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 3/8/25.
//

import SwiftUI

struct GrayPlainButton: View {
    let title: String
    let action: () -> Void
    
    init(
        title: String,
        action: @escaping () -> Void = {}
    ) {
        self.title = title
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(Colors.GrayScale.grayscal45)
                .fontStyle(Fonts.body1Medium)
        }
        .frame(width: 71, height: 45)
    }
}
