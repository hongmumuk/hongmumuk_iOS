//
//  PrivacyModalView.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 3/2/25.
//

import SwiftUI

struct PrivacyModalView: View {
    var title: String
    var content: String
    var onDismiss: () -> Void
    var agreeAction: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                closeButton
                    .padding(.top, 16)
                    .padding(.horizontal, 20)
                
                ZStack {
                    scrollView
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, geometry.size.height * 0.2)
                    
                    VStack {
                        Spacer()
                        
                        LinearGradient(
                            gradient: Gradient(colors: [Color.white.opacity(0.15), Color.white.opacity(0.8)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: geometry.size.height * 0.3)
                        .padding(.bottom, geometry.size.height * 0.1)
                    }
                    .allowsHitTesting(false)
                    
                    VStack {
                        Spacer()
                        agreeButton
                            .buttonStyle(PlainButtonStyle())
                            .frame(height: 60)
                            .padding(.bottom, geometry.size.height * 0.1)
                            .padding(.horizontal, 24)
                    }
                }
            }
            .presentationDetents([.medium])
        }
    }
    
    private var closeButton: some View {
        HStack {
            Spacer()
            
            Button(action: onDismiss) {
                Image("modalCloseIcon")
            }
            .frame(width: 30, height: 30)
        }
    }
    
    private var scrollView: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(title)
                    .fontStyle(Fonts.title2Bold)
                    .foregroundColor(Colors.GrayScale.normal)
                    .padding(.horizontal, 24)
                
                Text(content)
                    .fontStyle(Fonts.body1Medium)
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                    .padding(.bottom, 30)
            }
        }
    }
    
    private var agreeButton: some View {
        Button(action: agreeAction) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Colors.Primary.normal)
                    .frame(height: 60)
                
                HStack(alignment: .center) {
                    Image("checkWhiteBlueIcon")
                        .frame(width: 24, height: 24)
                        .padding(.leading, 20)
                    
                    Spacer()
                }
                
                Text("약관에 동의합니다")
                    .fontStyle(Fonts.heading2Bold)
                    .foregroundColor(.white)
            }
        }
    }
}
