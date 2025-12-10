//
//  ContentView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 1/19/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ScrollView {
                VStack(spacing: 0) {
                    HMLargeTitle(title: "오늘의 추천 맛집")
                    HMLagePhotoList()
                    HMLargeTitle(title: "에디터 추천 5선")
                    HMMediumPhotoList()
                    HMLargeTitle(title: "새로운 장소가 궁금하다면?")
                    HMSmallPhotoList(items: tagSmallCards)
                    HMLargeTitle(title: "카테고리별로 볼래요")
                    HMFilter(isImage: true)
                    HMSmallPhotoList(items: categorySmallCards)
                    Spacer()
                }
            }
            .padding(.top)
            .tabItem {
                Image(systemName: "house.fill")
                Text("홈")
            }

            ScrollView {
                VStack(spacing: 0) {
                    HMFilter(isImage: false)
                    HMLargeTitle(title: "카페")
                    HMSmallPhotoList(items: cafeBenefitCards)
                    HMLargeTitle(title: "음식점")
                    HMSmallPhotoList(items: restaurantBenefitCards)
                    HMLargeTitle(title: "생활/문화")
                    HMSmallPhotoList(items: lifeCultureBenefitCards)
                    Spacer()
                }
            }
            .padding(.top)
            .tabItem {
                Image(systemName: "tag.fill")
                Text("혜택")
            }
        }
    }
}
