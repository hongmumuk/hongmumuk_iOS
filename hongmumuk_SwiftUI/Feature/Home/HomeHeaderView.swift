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
        HStack {
            Image("homeLogo")
                .resizable()
                .scaledToFit()
                .frame(height: 32)
            Spacer()
            Button(action: {
                viewStore.send(.searchButtonTapped)
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
