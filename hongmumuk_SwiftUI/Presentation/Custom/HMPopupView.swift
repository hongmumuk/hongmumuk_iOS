//
//  HMPopupView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 7/7/26.
//
import SwiftUI

struct HMPopupView: View {
    let onClose: () -> Void
    let onTapPost: () -> Void
    
    var body: some View {
        mainContent()
            .ignoresSafeArea()
    }
    
    func mainContent() -> some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                imgSubTitle()
                imgTitle()
            }
            .background(.black)
            
            title()
            subTitle()
            viewButton()
            closeButton()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 464)
        .background(.white)
        .cornerRadius(20)
        .padding(.horizontal, 20)
    }
    
    func imgSubTitle() -> some View {
        HStack {
            Text("에디터가 직접 먹어 본")
                .font(Fonts.body1Medium.toFont())
                .foregroundColor(.white)
            
            Spacer()
        }
    }
    
    func imgTitle() -> some View {
        HStack {
            Text("홍대 주변 한식 맛집 zip")
                .font(Fonts.title2Bold.toFont())
                .foregroundColor(.white)
                .padding(.bottom, 12)
            
            Spacer()
        }
    }
    
    func title() -> some View {
        Text("이달의 포스트가 나왔어요!")
            .font(Fonts.heading2Bold.toFont())
            .foregroundColor(Colors.Label.Normal.strong)
            .padding(.bottom, 12)
    }
    
    func subTitle() -> some View {
        Text("에디터가 직접 다녀온\n홍대 저녁 맛집 5곳을 한 번에 모아봤어요.")
            .multilineTextAlignment(.center)
            .font(Fonts.heading3Medium.toFont())
            .foregroundColor(Colors.Label.Normal.neutral)
            .padding(.bottom, 24)
    }
    
    func viewButton() -> some View {
        Button(action: onTapPost) {
            Text("포스트 보러 가기")
                .font(Fonts.heading2Bold.toFont())
                .foregroundStyle(.white)
        }
        .frame(height: 60)
        .frame(maxWidth: .infinity)
        .background(Colors.Primary.normal)
        .cornerRadius(20)
        .padding(.horizontal, 20)
        .padding(.bottom, 12)
    }
    
    func closeButton() -> some View {
        Button(action: onClose) {
            Text("닫기")
                .font(Fonts.body1SemiBold.toFont())
                .foregroundColor(Colors.Label.Normal.alternative)
                .foregroundStyle(.white)
        }
        .background(.clear)
    }
}
