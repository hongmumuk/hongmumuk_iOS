//
//  HomeHeaderView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/13/25.
//

import ComposableArchitecture
import SwiftUI

// MARK: - HeaderView

struct HomeHeaderView: View {
    @ObservedObject var viewStore: ViewStoreOf<HomeFeature>
    @ObservedObject var parentViewStore: ViewStoreOf<RootFeature>
    
    var body: some View {
        VStack {
            header
                .frame(height: 56)
                .padding(.horizontal, 24)
                .overlay(bottomBorderLine, alignment: .bottom)
            Spacer()
        }
    }
    
    private var header: some View {
        HStack(spacing: 0) {
            Image("navigationLogoIcon")
                .resizable()
                .frame(width: 32, height: 32)
                .padding(.trailing, 4)
            
            Image("navigationTypoIcon")
                .resizable()
                .frame(width: 68, height: 32)
            
            Spacer()
            Button(action: {
                parentViewStore.send(.navigationTo(.search))
            }) {
                Image("searchIcon")
                    .frame(width: 36, height: 36)
            }
        }
    }
    
    private var bottomBorderLine: some View {
        Rectangle()
            .frame(height: 1)
            .foregroundColor(Colors.Border.neutral)
    }
}
