//
//  LottieView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 3/3/25.
//

import Lottie
import SwiftUI

struct LottieView: UIViewRepresentable {
    // 입력받을 파일명과 loopMode
    let fileName: String
    let loopMode: LottieLoopMode
    
    func makeUIView(context: Context) -> Lottie.LottieAnimationView {
        let animationView = LottieAnimationView(name: fileName)
        // 입력한 loopMode로 재생
        animationView.loopMode = loopMode
        animationView.play()
        
        return animationView
    }
    
    func updateUIView(_ uiView: LottieAnimationView, context: Context) {}
}
