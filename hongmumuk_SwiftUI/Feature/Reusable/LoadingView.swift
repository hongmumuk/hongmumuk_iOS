//
//  LoadingView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 3/3/25.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            LottieView(fileName: "Loading", loopMode: .loop)
                .frame(width: 240, height: 240)
        }
        .padding(.top, 20)
    }
}
