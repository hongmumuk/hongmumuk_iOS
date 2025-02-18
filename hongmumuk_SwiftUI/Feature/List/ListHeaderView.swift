//
//  ListHeaderView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/17/25.
//

import ComposableArchitecture
import SwiftUI

struct ListHeaderView: View {
    @ObservedObject var viewStore: ViewStoreOf<ListFeature>
    @SwiftUI.Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            header
                .frame(height: 56)
                .padding(.horizontal, 24)
        }
    }
    
    private var header: some View {
        HStack {
            backButton
            Spacer()
            categoryText
            Spacer()
            searchButton
        }
    }
    
    private var backButton: some View {
        Button(action: {
            dismiss()
        }) {
            Image("backIcon")
                .frame(width: 36, height: 36)
        }
    }
    
    private var categoryText: some View {
        Text(viewStore.cateogry.displayName)
            .fontStyle(Fonts.heading1Bold)
            .foregroundColor(Colors.GrayScale.grayscale95)
    }
    
    private var searchButton: some View {
        Button(action: {
            viewStore.send(.searchButtonTapped)
        }) {
            Image("searchIcon")
                .frame(width: 36, height: 36)
        }
    }
}
