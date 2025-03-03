//
//  SearchEmptyView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 3/3/25.
//

import SwiftUI

import ComposableArchitecture

struct SearchEmptyView: View {
    @ObservedObject var viewStore: ViewStoreOf<SearchFeature>
    
    var body: some View {
        VStack {
            Spacer()
            EmptyView(type: .search) {
                viewStore.send(.inquryButtonTapped)
            }
            Spacer()
        }
    }
}
