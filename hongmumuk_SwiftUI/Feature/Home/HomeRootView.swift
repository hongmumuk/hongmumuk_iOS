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
    let parentStore: StoreOf<RootFeature>
    
    @ObservedObject var parentViewStore: ViewStoreOf<RootFeature>
    @State private var selectedTab: Tab = .home
    
    init(parentStore: StoreOf<RootFeature>) {
        self.parentStore = parentStore
        parentViewStore = ViewStore(parentStore, observe: { $0 })
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(
                store: Store(
                    initialState: HomeFeature.State(),
                    reducer: HomeFeature.init
                ), parentStore: parentStore
            )
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
