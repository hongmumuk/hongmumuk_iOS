//
//  HomeRootView.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 3/5/25.
//

import ComposableArchitecture
import SwiftUI

enum Tab {
    case home, like, profile
}

struct HomeRootView: View {
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
