//
//  ContentView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 1/19/25.
//

import SwiftUI

struct ContentView: View {
    @State var showDetail = false
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("홈")
                }
            
            PartnerlView()
                .tabItem {
                    Image(systemName: "tag.fill")
                    Text("혜택")
                }
        }
    }
}
