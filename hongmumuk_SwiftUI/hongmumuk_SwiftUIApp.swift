//
//  hongmumuk_SwiftUIApp.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 1/19/25.
//

import ComposableArchitecture
import SwiftUI

@main
struct Hongmumuk_SwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

enum Tab {
    case home, like, profile
}

struct RootView: View {
    @State private var selectedTab: Tab = .home

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(
                store: Store(
                    initialState: HomeFeature.State(),
                    reducer: HomeFeature.init
                ))
                .tabItem {
                    Image(selectedTab == .home ?"homeSelectedIcon" : "homeIcon")
                }
                .tag(Tab.home)
            
            LikeView(
                store: Store(
                    initialState: LikeFeature.State(),
                    reducer: { LikeFeature() },
                    withDependencies: {
                        $0.likeClient = .testValue
                    }
                )
            )
            .tabItem {
                Image(selectedTab == .like ? "likeSelectedIcon" : "likeIcon")
            }
            .tag(Tab.like)

            ProfileView()
                .tabItem {
                    Image(selectedTab == .profile ? "profileSelectedIcon" : "profileIcon")
                }
                .tag(Tab.profile)
        }
    }
}
