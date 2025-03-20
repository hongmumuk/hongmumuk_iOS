//
//  WebContentView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 3/6/25.
//

import SwiftUI
import WebKit

struct WebContentView: View {
    let urlString: String
    
    var body: some View {
        VStack {
            WKWebViewPresentable(urlString)
        }
        .padding()
    }
}

struct WKWebViewPresentable: UIViewRepresentable {
    let urlString: String

    init(_ urlString: String) {
        self.urlString = urlString
    }

    func makeUIView(context: Context) -> WKWebView {
        WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
}
