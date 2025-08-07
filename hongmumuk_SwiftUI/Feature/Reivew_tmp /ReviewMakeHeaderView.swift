//
//  ReviewMakeHeaderView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 7/7/25.
//

import SwiftUI

import ComposableArchitecture

struct ReviewMakeHeaderView: View {
    @ObservedObject var viewStore: ViewStoreOf<ReviewMakeFeature>
    @SwiftUI.Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            header
                .frame(height: 60)
                .padding(.horizontal, 24)
        }
    }
    
    private var header: some View {
        ZStack {
            restaurantTitle
            dismissButton
        }
    }
    
    private var restaurantTitle: some View {
        Text(viewStore.restaurantName)
            .fontStyle(Fonts.heading1Bold)
            .foregroundColor(Colors.GrayScale.grayscale95)
    }
    
    private var dismissButton: some View {
        HStack {
            Spacer()
            Button(action: {
                viewStore.send(.dismissButtonTapped)
            }) {
                Image("dismissIcon")
                    .frame(width: 36, height: 36)
            }
        }
    }
}
