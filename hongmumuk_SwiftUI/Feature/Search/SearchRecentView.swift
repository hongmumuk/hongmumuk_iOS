//
//  SearchRecentView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/15/25.
//

import ComposableArchitecture
import SwiftUI

struct RecentSearchView: View {
    @ObservedObject var viewStore: ViewStoreOf<SearchFeature>
    
    var body: some View {
        VStack(alignment: .leading) {
            recentSearchTextView
            if viewStore.recentSearchList.isEmpty { recentSearchEmptyTextView }
            else { recentSearchItemView }
        }
        .padding(.horizontal, 20)
    }
    
    private var recentSearchTextView: some View {
        HStack {
            Text("최근 검색 결과")
                .fontStyle(Fonts.body2SemiBold)
                .foregroundColor(Colors.GrayScale.grayscal45)
                .padding(.top, 24)
            
            Spacer()
            
            Button(action: {
                viewStore.send(.recentSearchAllClearButtonTapped)
            }) {
                Text("전체 삭제")
                    .fontStyle(Fonts.body2Medium)
                    .foregroundColor(Colors.GrayScale.grayscale30)
                    .padding(.top, 26)
            }
            .padding(.leading, 8)
        }
    }
    
    private var recentSearchEmptyTextView: some View {
        HStack {
            Spacer()
            Text("최근 검색 결과가 없습니다.")
                .font(.system(size: 14))
                .foregroundColor(.gray)
            Spacer()
        }
        .frame(height: 16)
        .padding(.top, 24)
    }
    
    private var recentSearchItemView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(viewStore.recentSearchList, id: \.self) { searchText in
                    HStack(spacing: 4) {
                        Text(searchText)
                            .fontStyle(Fonts.body1Medium)
                            .foregroundColor(Colors.GrayScale.grayscale70)
                            .padding(.vertical, 6)
                        
                        Button(action: {
                            viewStore.send(.recentSearchClearButtonTapped(searchText))
                        }) {
                            Image("xIcon")
                                .resizable()
                                .frame(width: 16, height: 16)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal, 12)
                    .background(recentSearchItemBackgroundView)
                    .onTapGesture {
                        viewStore.send(.recentSearchTapped(searchText))
                    }
                }
            }
        }
        .padding(.top, 12)
    }
    
    private var recentSearchItemBackgroundView: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Colors.GrayScale.grayscale5)
            .stroke(Colors.Border.normal)
    }
}
