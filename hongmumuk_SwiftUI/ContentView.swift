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
            
            ScrollView {
                VStack(spacing: 0) {
                    HMFilter(isImage: false)
                    HMLargeTitle(title: "카페")
                    HMSmallPhotoList(items: cafeBenefitCards)
                    HMLargeTitle(title: "음식점")
                    HMSmallPhotoList(items: restaurantBenefitCards)
                    HMLargeTitle(title: "생활/문화")
                    HMSmallPhotoList(items: lifeCultureBenefitCards)
                    Spacer()
                }
            }
            .padding(.top)
            .tabItem {
                Image(systemName: "tag.fill")
                Text("혜택")
            }
        }
        .task {
            do {
                let result = try await SupabaseService.shared.getScreen(for: .home)
                print("result", result)
            } catch {
                print("error", error)
            }
        }
    }
}
