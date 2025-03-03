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
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
}
