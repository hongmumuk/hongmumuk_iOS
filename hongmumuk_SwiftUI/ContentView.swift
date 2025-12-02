//
//  ContentView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 1/19/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 0) {
            HMLargeTitle(title: "오늘의 추천 맛집")
            HMLagePhotoList()
            HMLargeTitle(title: "에디터 추천 5선")
            HMMediumPhotoList()
            Spacer()
        }
        .padding(.vertical)
    }
}
