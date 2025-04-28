//
//  OnboardingView.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 3/15/25.
//

import ComposableArchitecture
import SwiftUI

struct TabItem {
    let title: String
    let imageName: String
}

struct OnboardingView: View {
    let store: StoreOf<OnboardingFeature>
    let parentStore: StoreOf<RootFeature>
    
    @ObservedObject var viewStore: ViewStoreOf<OnboardingFeature>
    @ObservedObject var parentViewStore: ViewStoreOf<RootFeature>
    
    init(store: StoreOf<OnboardingFeature>, parentStore: StoreOf<RootFeature>) {
        self.store = store
        self.parentStore = parentStore
        viewStore = ViewStore(store, observe: { $0 })
        parentViewStore = ViewStore(parentStore, observe: { $0 })
    }
    
    let tabItems: [TabItem] = [
        TabItem(title: "category_recommendation_description".localized(), imageName: "onboarding1"),
        TabItem(title: "random_recommendation_description".localized(), imageName: "onboarding2"),
        TabItem(title: "check_location_keyword_review".localized(), imageName: "onboarding3")
    ]

    var body: some View {
        GeometryReader { geometry in
            let safeAreaHeight = geometry.safeAreaInsets.top
            VStack(spacing: 0) {
                tabView(safeAreaHeight: safeAreaHeight)
                Divider()
                    .foregroundStyle(Colors.Border.strong)
                    .frame(height: 1)
                progressBar
                
                Spacer()
                
                LoginButton(
                    title: "start_hongmumuk".localized(),
                    iconName: "whiteIcon",
                    backgroundColor: Colors.Primary.normal,
                    textColor: .white,
                    action: {
                        Task {
                            await parentStore.send(.onboardingCompleted)
                        }
                    }
                )
                .frame(height: 60)
                .padding(.horizontal, 24)
                .padding(.bottom, 28)
                
                Button(action: {
                    Task {
                        await parentStore.send(.onboardingCompleted)
                        await parentStore.send(.setNavigationRoot(.home))
                    }
                }, label: {
                    Text("start_as_guest".localized())
                        .fontStyle(Fonts.body1Medium)
                        .foregroundColor(Colors.GrayScale.alternative)
                })
                .padding(.bottom, geometry.size.height * 0.1)
            }
            .ignoresSafeArea(.container, edges: .top)
        }
    }
    
    private func tabView(safeAreaHeight: CGFloat) -> some View {
        TabView(selection: Binding(
            get: { viewStore.currentPage },
            set: { viewStore.send(.currentPageChanged($0)) }
        )) {
            ForEach(0 ..< tabItems.count, id: \.self) { index in
                components(index, safeAreaHeight: safeAreaHeight)
                    .tag(index)
            }
        }
        .frame(height: UIScreen.main.bounds.height * 0.72 - safeAreaHeight)
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
    
    private func components(_ index: Int, safeAreaHeight: CGFloat) -> some View {
        ZStack(alignment: .top) {
            Image(tabItems[index].imageName)
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.72)
                .clipped()
                .offset(y: -safeAreaHeight)
                
            Text(tabItems[index].title)
                .fontStyle(Fonts.title2Bold)
                .foregroundStyle(Colors.GrayScale.normal)
                .padding(.top, UIScreen.main.bounds.height * 0.12)
        }
    }
    
    private var progressBar: some View {
        HStack {
            ForEach(0 ..< tabItems.count, id: \.self) { index in
                Circle()
                    .fill(index == viewStore.currentPage ? Colors.Primary.normal : Colors.GrayScale.assistive)
                    .frame(width: 8, height: 8)
            }
        }
        .padding(.top, 28)
    }
}
