//
//  ListItemView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/18/25.
//

import SwiftUI

struct ListItemView: View {
    let item: RestaurantListModel
    let sort: Sort
    let action: (RestaurantListModel) -> Void
    
    var body: some View {
        Button(action: {
            action(item)
        }) {
            HStack(spacing: 12) {
                OptimizedAsyncImage(
                    url: URL(string: item.imageUrl ?? ""),
                    targetSize: CGSize(width: 300, height: 300)
                ) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                } placeholder: {
                    ZStack {
                        Color.clear
                            .frame(width: 100, height: 100)
                        
                        Image(item.category.rawValue)
                            .resizable()
                            .frame(width: 48, height: 48)
                    }
                }
                .cornerRadius(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Colors.GrayScale.grayscale5)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(Colors.Border.neutral, lineWidth: 1)
                )
                .frame(width: 100, height: 100)

                VStack(alignment: .leading) {
                    Text(item.name)
                        .lineLimit(1)
                        .fontStyle(Fonts.heading2Bold)
                        .foregroundColor(Colors.GrayScale.grayscale95)
                        .padding(.bottom, 4)
                    
                    Text(item.category.displayName)
                        .fontStyle(Fonts.body2SemiBold)
                        .foregroundColor(Colors.GrayScale.grayscal45)
                        .padding(.bottom, 16)
                    
                    HStack(spacing: 12) {
                        HStack(spacing: 4) {
                            Image("heartSmallIcon")
                                .foregroundColor(Colors.GrayScale.grayscale55)
                            Text("\(item.likes)")
                                .foregroundColor(Colors.GrayScale.grayscale55)
                        }
                        
                        HStack(spacing: 4) {
                            switch sort {
                            case .likes:
                                Spacer()
                            case .front:
                                Image("distanceIcon")
                                    .foregroundColor(Colors.GrayScale.grayscale55)
                                
                                Text("정문에서")
                                    .foregroundColor(Colors.GrayScale.grayscale55)
                                
                                Text("\(Int(item.frontDistance))m")
                                    .foregroundColor(Colors.GrayScale.grayscale55)
                            case .back:
                                Image("distanceIcon")
                                    .foregroundColor(Colors.GrayScale.grayscale55)
                                
                                Text("후문에서")
                                    .foregroundColor(Colors.GrayScale.grayscale55)
                                
                                Text("\(Int(item.backDistance))m")
                                    .foregroundColor(Colors.GrayScale.grayscale55)
                            case .name:
                                Spacer()
                            }
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

struct ListItemSkeletonItemView: View {
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
