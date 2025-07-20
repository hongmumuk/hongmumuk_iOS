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
                DetailReviewView(viewStore: viewStore)
                    .tag(1)
                
                // BlogView
                DetailBlogView(viewStore: viewStore)
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            if viewStore.showToast {
                copyToast
                    .padding(.bottom, 152)
            }
        }
    }
    
    private var copyToast: some View {
        HStack(spacing: 10) {
            Image("checkWhiteIcon")
                .resizable()
                .frame(width: 20, height: 20)
            
            Text("copied_store_address".localized())
                .fontStyle(Fonts.heading3Medium)
                .foregroundColor(.white)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.black.opacity(0.7))
        )
    }
}
