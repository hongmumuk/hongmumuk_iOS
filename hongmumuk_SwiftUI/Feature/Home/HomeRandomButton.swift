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
        RandomButton {
            viewStore.send(.randomButtonTapped)
        }
    }
}
