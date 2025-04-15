//
//  SignupDoneView.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 3/2/25.
//

import ComposableArchitecture
import SwiftUI

struct SignupDoneView: View {
    let parentStore: StoreOf<RootFeature>
    
    @ObservedObject var parentViewStore: ViewStoreOf<RootFeature>
    
    init(parentStore: StoreOf<RootFeature>) {
        self.parentStore = parentStore
        parentViewStore = ViewStore(parentStore, observe: { $0 })
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Image("doneImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width * 0.42, height: geometry.size.width * 0.42)
                    .padding(.top, geometry.size.height * 0.24)
                
                Text("welcome_to_hongmumuk".localized())
                    .fontStyle(Fonts.title2Bold)
                    .foregroundStyle(Colors.GrayScale.normal)
                    .padding(.top, 12)
                
                Text("use_all_services_now".localized())
                    .fontStyle(Fonts.heading3Medium)
                    .foregroundStyle(Colors.GrayScale.alternative)
                    .padding(.top, 8)
                
                Spacer()
                
                NextButton(title: "start".localized(), isActive: true) {
                    parentStore.send(.setNavigationRoot(.login))
                }
                .frame(height: 60)
                .padding(.horizontal, 24)
                .padding(.bottom, geometry.size.height * 0.1)
            }
        }
    }
}
