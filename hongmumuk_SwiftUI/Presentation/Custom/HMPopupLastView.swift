//
//  HMPopupLastView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 7/18/26.
//

import Kingfisher
import SwiftUI

struct HMPopupLastView: View {
    let onClose: () -> Void
    let onTapPost: () -> Void
    
    var body: some View {
        mainContent()
            .ignoresSafeArea()
    }
    
    func mainContent() -> some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 0) {
                buttonStack()
                titleStack()
                viewButton()
            }
            
            logoImage()
        }
        .frame(maxWidth: .infinity)
        .background(Colors.Primary.normal)
        .cornerRadius(20)
        .padding(.horizontal, 20)
    }
    
    func logoImage() -> some View {
        Image("popupLogo")
    }
    
    // MARK: - 상단 버튼 영역
    
    func buttonStack() -> some View {
        HStack {
            Spacer()
            
            Button(action: onClose) {
                Image(systemName: "xmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .foregroundStyle(Colors.Label.Normal.assisitive)
            }
            .frame(width: 32, height: 32)
            .background(Color.black.opacity(0.6))
            .clipShape(Circle())
        }
        .padding(.top, 20)
        .padding(.horizontal, 20)
    }
    
    // MARK: - 중간 title 영역
    
    func titleStack() -> some View {
        VStack(alignment: .center) {
            title()
            subTitle()
        }
        .padding(.bottom, 60)
        .padding(.top, 120)
    }
    
    func title() -> some View {
        Text("방금 본 홍대 저녁 맛집\n리스트 보러 가기")
            .multilineTextAlignment(.center)
            .font(Fonts.heading2Bold.toFont())
            .foregroundColor(Colors.Label.Normal.disable)
            .padding(.bottom, 12)
    }
    
    func subTitle() -> some View {
        Text("맛집 지도와 영업시간까지\n한 번에 볼 수 있어요!")
            .multilineTextAlignment(.center)
            .font(Fonts.heading3Medium.toFont())
            .foregroundColor(Colors.Label.Normal.assisitive)
    }
    
    // MARK: - 하단 버튼 영역
    
    func viewButton() -> some View {
        Button(action: onTapPost) {
            Text("맛집 리스트 보러가기")
                .font(Fonts.heading2Bold.toFont())
                .foregroundStyle(Colors.Primary.normal)
        }
        .frame(height: 60)
        .frame(maxWidth: .infinity)
        .background(Colors.Primary.alternative)
        .cornerRadius(20)
        .padding(.horizontal, 20)
        .padding(.bottom, 94)
    }
}
