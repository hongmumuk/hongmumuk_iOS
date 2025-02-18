//
//  ListRandomButton.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/17/25.
//

import ComposableArchitecture
import SwiftUI

struct ListRandomButton: View {
    @ObservedObject var viewStore: ViewStoreOf<ListFeature>
    
    var body: some View {
        RandomButton {
            viewStore.send(.randomButtonTapped)
        }
    }
}
