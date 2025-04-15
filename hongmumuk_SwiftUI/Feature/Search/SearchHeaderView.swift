//
//  SearchHeaderView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/15/25.
//

import ComposableArchitecture
import SwiftUI

struct SearchHeaderView: View {
    @ObservedObject var viewStore: ViewStoreOf<SearchFeature>
    @SwiftUI.Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            header
                .frame(height: 56)
                .padding(.horizontal, 24)
                .overlay(bottomBorderLine, alignment: .bottom)
        }
    }
    
    private var bottomBorderLine: some View {
        Rectangle()
            .frame(height: 1)
            .foregroundColor(Colors.Border.neutral)
    }
    
    private var header: some View {
        HStack(spacing: 12) {
            backButton
            searchBar
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
    
    private var searchBar: some View {
        HStack {
            searchTextField
            searchBarHelperView
        }
        .padding(.horizontal, 20)
        .background(searchBarBackgroundView)
    }
    
    private var searchTextField: some View {
        TextField("search_manually".localized(), text:
            viewStore.binding(
                get: \.searchText,
                send: SearchFeature.Action.searchBarOnChanged
            ))
            .fontStyle(Fonts.heading3Medium)
            .tint(Colors.Primary.primary55)
            .frame(height: 44)
            .onSubmit {
                viewStore.send(.searchBarOnSubmit)
            }
    }
    
    private var searchBarBackgroundView: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Colors.GrayScale.grayscale5)
    }
    
    private var searchBarHelperView: some View {
        HStack {
            if viewStore.isVisibleClearButton { searchBarClearButton }
            else { searchBlueImageView }
        }
    }
    
    private var searchBlueImageView: some View {
        Image("searchBlueIcon")
            .frame(width: 20, height: 20)
    }
    
    private var searchBarClearButton: some View {
        Button(action: {
            viewStore.send(.searchBarClearButtonTapped)
        }) {
            Image("searchClearIcon")
                .frame(width: 20, height: 20)
        }
    }
}
