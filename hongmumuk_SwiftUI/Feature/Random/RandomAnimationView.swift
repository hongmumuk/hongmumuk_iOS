//
//  RandomAnimationView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 3/14/25.
//

import SwiftUI

import ComposableArchitecture

struct RandomAnimationView: View {
    @ObservedObject var viewStore: ViewStoreOf<RandomFeature>
    @State private var centered: Bool = false
    @State private var showRandomBowl: Bool = false
    
    var body: some View {
        ZStack {
            koreanBowl
                .rotationEffect(.degrees(centered ? 0 : 15))
                .offset(x: centered ? 0 : -45, y: centered ? 0 : -99)
                .opacity(centered ? 0 : 1)
            
            chinaBowl
                .rotationEffect(.degrees(centered ? 0 : -30))
                .offset(x: centered ? 0 : 67, y: centered ? 0 : -49)
                .opacity(centered ? 0 : 1)
            
            japaneseBowl
                .rotationEffect(.degrees(centered ? 0 : 55))
                .offset(x: centered ? 0 : -67, y: centered ? 0 : 42)
                .opacity(centered ? 0 : 1)
            
            fastfoodBowl
                .rotationEffect(.degrees(centered ? 0 : -120))
                .offset(x: centered ? 0 : 40, y: centered ? 0 : 90)
                .opacity(centered ? 0 : 1)
            
            randomBowl
                .offset(x: 0, y: showRandomBowl ? 54 : 0)
                .fixedSize()
                .opacity(showRandomBowl ? 1 : 0)
                .animation(
                    .spring(
                        response: 0.6,
                        dampingFraction: 0.3,
                        blendDuration: 0.3
                    ),
                    value: showRandomBowl
                )
        }
        .padding(.horizontal, 24)
        .padding(.top, 56)
        .animation(.spring(response: 0.8), value: centered)
        .onChange(of: viewStore.startPick) { _, value in
            if value {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    centered = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        showRandomBowl = true
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            viewStore.send(.endAnimation, animation: .easeIn(duration: 0.2))
                        }
                    }
                }
            }
        }
    }
    
    private var koreanBowl: some View {
        Image("randomAnimiation1")
    }
    
    private var chinaBowl: some View {
        Image("randomAnimiation2")
    }
    
    private var japaneseBowl: some View {
        Image("randomAnimiation3")
    }
    
    private var fastfoodBowl: some View {
        Image("randomAnimiation4")
    }
    
    private var randomBowl: some View {
        Image("randomAnimiation5")
    }
}
