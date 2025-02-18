//
//  RandomButton.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/18/25.
//

import SwiftUI

struct RandomButton: View {
    let action: () -> Void
    
    var body: some View {
        VStack {
            Button(action: action) {
                Image("randomIcon")
                    .frame(width: 76, height: 76)
            }
            .background(Colors.Primary.normal)
            .cornerRadius(28)
            .padding(.bottom, 24)
            .padding(.trailing, 24)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        }
    }
}
    