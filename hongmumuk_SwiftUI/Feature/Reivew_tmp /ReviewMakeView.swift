//
//  ReviewMakeView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 7/7/25.
//

import SwiftUI

import ComposableArchitecture

struct ReviewMakeView: View {
    private let store: StoreOf<ReviewMakeFeature>
    @ObservedObject var viewStore: ViewStoreOf<ReviewMakeFeature>
    
    init(store: StoreOf<ReviewMakeFeature>) {
        self.store = store
        viewStore = ViewStore(store, observe: { $0 })
    }
    
    var body: some View {
        Text("ReviewMakeView")
    }
}
