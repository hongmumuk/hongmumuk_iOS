//
//  CategoryRandomButton.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/17/25.
//

import ComposableArchitecture
import SwiftUI

struct CategoryRandomButton: View {
    @ObservedObject var viewStore: ViewStoreOf<CategoryFeature>
    
    var body: some View {
        RandomButton {
            viewStore.send(.randomButtonTapped)
        }
    }
}
