//
//  WebView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 3/6/25.
//

import SwiftUI

import ComposableArchitecture

struct WebView: View {
    let title: String
    let urlString: String
    private let parentStore: StoreOf<RootFeature>
    @ObservedObject var parentViewStore: ViewStoreOf<RootFeature>
    
    init(
        title: String,
        urlString: String,
        parentStore: StoreOf<RootFeature>
    ) {
        self.title = title
        self.urlString = urlString
        self.parentStore = parentStore
        parentViewStore = ViewStore(parentStore, observe: { $0 })
    }
    
    var body: some View {
        VStack {
            WebViewHeader(title: title, parentViewStore: parentViewStore)
            WebContentView(urlString: urlString)
        }
    }
}
