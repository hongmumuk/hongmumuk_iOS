//
//  HomeRandomButton.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/13/25.
//

import ComposableArchitecture
import SwiftUI

struct HomeRandomButton: View {
    @ObservedObject var viewStore: ViewStoreOf<HomeFeature>
    
    var body: some View {
        VStack {
            Button(action: {
                viewStore.send(.randomButtonTapped)
            }) {
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
