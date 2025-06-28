//
//  DetailPopButton.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 6/28/25.
//

import SwiftUI

struct DetailPopButton: View {
    let action: () -> Void
    
    init(action: @escaping () -> Void = {}) {
        self.action = action
    }
    
    var body: some View {
        HStack {
            Spacer()
            
            Button(action: {
                action()
            }) {
                Image("closeButton")
                    .frame(width: 30, height: 30)
            }
        }
        .padding(.horizontal, -8)
    }
}
