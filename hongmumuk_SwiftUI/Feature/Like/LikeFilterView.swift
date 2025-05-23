//
//  LikeFilterView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/18/25.
//

import ComposableArchitecture
import SwiftUI

struct LikeFilterView: View {
    @ObservedObject var viewStore: ViewStoreOf<LikeFeature>
    
    var body: some View {
        VStack {
            filterView
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
    
    private var filterView: some View {
        HStack {
            restrauntCntText
            Spacer()
            sortButton
        }
    }
    
    private var restrauntCntText: some View {
        Text("restaurant_count".localized(variables: viewStore.restrauntCount))
            .fontStyle(Fonts.body1Medium)
            .foregroundColor(Colors.GrayScale.grayscal45)
    }
    
    private var sortButton: some View {
        Button(action: {
            viewStore.send(.sortButtonTapped)
        }) {
            HStack(spacing: 4) {
                Text("\(viewStore.sort.displayName)")
                    .foregroundColor(Colors.Primary.primary60)
                    .fontStyle(Fonts.body1SemiBold)
                Image("dropDownIcon")
                    .frame(width: 16, height: 16)
            }
        }
        .actionSheet(isPresented: Binding(
            get: { viewStore.showSortSheet },
            set: { newValue in
                if !newValue {
                    viewStore.send(.onDismiss)
                }
            }
        )) {
            let removeCurrentSort = Sort.allCases.filter { $0 != viewStore.sort }
            
            var buttons: [ActionSheet.Button] = removeCurrentSort.map { sort in
                .default(Text("\(sort.displayName)")) {
                    viewStore.send(.sortChanged(sort))
                }
            }
            
            buttons.append(.cancel(Text("cancel".localized()), action: {
                viewStore.send(.onDismiss)
            }))
            
            return ActionSheet(
                title: Text("정렬 기준"),
                buttons: buttons
            )
        }
    }
}
