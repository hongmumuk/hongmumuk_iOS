//
//  SplashView.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 3/5/25.
//

import ComposableArchitecture
import SwiftUI

struct SplashView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Image("Logo_Blue")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width * 0.23)
                    .padding(.top, geometry.size.height * 0.28)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
