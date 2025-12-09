//
//  ContentView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 1/19/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                HMLargeTitle(title: "오늘의 추천 맛집")
                HMLagePhotoList()
                HMLargeTitle(title: "에디터 추천 5선")
                HMMediumPhotoList()
                HMLargeTitle(title: "새로운 장소가 궁금하다면?")
                HMSmallPhotoList(items: tagSmallCards)
                HMLargeTitle(title: "카테고리별로 볼래요")
                HMFilter()
                HMSmallPhotoList(items: categorySmallCards)
                HMLargeTitle(title: "카페")
                HMSmallPhotoList(items: cafeBenefitCards)
                Spacer()
            }
        }
        .padding(.vertical)
    }
}
