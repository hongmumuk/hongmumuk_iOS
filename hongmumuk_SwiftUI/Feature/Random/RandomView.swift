//
//  RandomView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/25/25.
//

import ComposableArchitecture
import SwiftUI

struct RandomView: View {
    private let store: StoreOf<RandomFeature>
    @ObservedObject var viewStore: ViewStoreOf<RandomFeature>
    
    init(store: StoreOf<RandomFeature>) {
        self.store = store
        viewStore = ViewStore(store, observe: { $0 })
    }
    
    var body: some View {
        VStack {
            Text("hello")
        }
    }
}
