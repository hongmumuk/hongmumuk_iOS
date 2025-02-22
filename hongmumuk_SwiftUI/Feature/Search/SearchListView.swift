//
//  SearchListView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/15/25.
//

import ComposableArchitecture
import Shimmer
import SwiftUI

struct SearchListView: View {
    @ObservedObject var viewStore: ViewStoreOf<SearchFeature>
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                if viewStore.isLoading {
                    ForEach(0 ..< 5, id: \.self) { _ in
                        SearchListItemSkeletonView()
                            .shimmering(active: true)
                    }
                } else {
                    ForEach(viewStore.searchedList) { item in
                        SearchListItemView(item: item) { viewStore.send(.restrauntTapped(id: $0.id)) }
                    }
                }
            }
        }
        .scrollDismissesKeyboard(.immediately)
        .padding(.top, 16)
    }
}

struct SearchListItemView: View {
    let item: RestaurantListModel
    let action: (RestaurantListModel) -> Void // 액션 클로저 추가
    
    var body: some View {
        Button(action: {
            action(item) // 버튼 탭 시 클로저 실행
        }) {
            HStack(spacing: 12) {
                // Store Image
                RoundedRectangle(cornerRadius: 16)
                    .fill(Colors.GrayScale.grayscale5)
                    .stroke(Colors.GrayScale.grayscale5)
                    .frame(width: 100, height: 100)
                
                // Store Information
                VStack(alignment: .leading) {
                    Text(item.name)
                        .fontStyle(Fonts.heading2Bold)
                        .foregroundColor(Colors.GrayScale.grayscale95)
                        .padding(.bottom, 4)
                    
                    Text(item.category)
                        .fontStyle(Fonts.body2SemiBold)
                        .foregroundColor(Colors.GrayScale.grayscal45)
                        .padding(.bottom, 16)
                    
                    HStack(spacing: 12) {
                        // Likes
                        HStack(spacing: 4) {
                            Image("heartSmallIcon")
                                .foregroundColor(Colors.GrayScale.grayscale55)
                            Text("\(item.likes)")
                                .foregroundColor(Colors.GrayScale.grayscale55)
                        }
                        
                        // Distance
                        HStack(spacing: 4) {
                            Image("distanceIcon")
                                .foregroundColor(Colors.GrayScale.grayscale55)
                            Text("현위치에서")
                                .foregroundColor(Colors.GrayScale.grayscale55)
                            Text("\(String(format: "%.1f", item.distance))km")
                                .foregroundColor(Colors.GrayScale.grayscale55)
                        }
                    }
                    .font(.system(size: 14))
                }
                .padding(.vertical, 9)
                
                Spacer()
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 24)
        }
    }
}

struct SearchListItemSkeletonView: View {
    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Colors.GrayScale.grayscale10)
                .frame(width: 100, height: 100)
            
            VStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Colors.GrayScale.grayscale10)
                    .frame(height: 23)
                    .padding(.bottom, 4)
                
                RoundedRectangle(cornerRadius: 6)
                    .fill(Colors.GrayScale.grayscale10)
                    .frame(height: 18)
                    .padding(.bottom, 16)
                
                HStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Colors.GrayScale.grayscale10)
                        .frame(width: 29, height: 21)
                    
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Colors.GrayScale.grayscale10)
                        .frame(width: 96, height: 21)
                }
            }
            .padding(.vertical, 9)
            
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 24)
    }
}
