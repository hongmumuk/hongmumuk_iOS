//
//  DetailTabView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/26/25.
//

import ComposableArchitecture
import SwiftUI

struct DetailTabView: View {
    @ObservedObject var viewStore: ViewStoreOf<DetailFeature>
    @ObservedObject var parentViewStore: ViewStoreOf<RootFeature>
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: viewStore.binding(
                get: { $0.pickerSelection },
                send: DetailFeature.Action.pickerSelectionChanged
            )) {
                // MAPView
                DetailMapView(viewStore: viewStore)
                    .tag(0)
                
                // ReviewView
                DetailReviewView(viewStore: viewStore, parentViewStore: parentViewStore)
                    .tag(1)
                
                // BlogView
                DetailBlogView(viewStore: viewStore)
                    .tag(2)
            }
            .tabViewStyle(.automatic)
            
            ToastView(
                imageName: viewStore.currentToast?.imageName ?? "",
                title: viewStore.currentToast?.message ?? ""
            )
            .frame(minWidth: UIScreen.main.bounds.width - 120)
            .padding(.bottom, 100)
            .opacity(viewStore.currentToast != nil ? 1.0 : 0.0)
            .scaleEffect(viewStore.currentToast != nil ? 1.0 : 0.8)
            .animation(.easeInOut(duration: 0.3), value: viewStore.currentToast != nil)
        }
    }
}
