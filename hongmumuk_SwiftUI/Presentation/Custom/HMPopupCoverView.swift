//
//  HMPopupCoverView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 7/7/26.
//
import Kingfisher
import SwiftUI

struct HMPopupCoverView: View {
    let props: HMPopupProps
    let items: [HMPopupItem]
    
    let onClose: () -> Void
    let onTapPost: () -> Void
    
    var body: some View {
        mainContent()
    }
    
    func mainContent() -> some View {
        VStack(spacing: 0) {
            cover()
            title()
            subTitle()
            viewButton()
            closeButton()
        }
        .frame(maxWidth: .infinity)
        .background(.white)
        .cornerRadius(20)
        .padding(.horizontal, 20)
    }
    
    // MARK: - Cover 영역
    
    func cover() -> some View {
        ZStack {
            coverImage()
            coverImgTitleSection()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 220)
        .padding(.bottom, 24)
    }
    
    func coverImage() -> some View {
        KFImage(URL(string: props.coverUrl))
            .cacheOriginalImage()
            .resizable()
            .scaledToFill()
            .frame(height: 220)
    }
    
    func coverImgTitleSection() -> some View {
        VStack(spacing: 0) {
            coverImgWeekTitle()
            Spacer()
            coverImgSubTitle()
            coverImgTitle()
        }
        .padding(.horizontal, 20)
    }
    
    func coverImgWeekTitle() -> some View {
        HStack(spacing: 0) {
            Text("MUMOOK?")
                .font(Fonts.body1Medium.toFont())
                .foregroundColor(Colors.Primary.normal)
                .padding(.vertical, 2)
                .padding(.horizontal, 6)
                .background(.white)
                .frame(height: 25)
            
            Text(props.weekLabel)
                .font(Fonts.body1Medium.toFont())
                .foregroundColor(.white)
                .padding(.vertical, 2)
                .padding(.horizontal, 6)
                .background(Colors.Primary.normal)
                .frame(height: 25)
            
            Spacer()
        }
        .padding(.top, 20)
    }
    
    func coverImgSubTitle() -> some View {
        HStack {
            Text(props.subtitle)
                .font(Fonts.body1Medium.toFont())
                .foregroundColor(.white)
                .padding(.bottom, 4)
            
            Spacer()
        }
    }
    
    func coverImgTitle() -> some View {
        HStack {
            Text(props.title)
                .font(Fonts.title2Bold.toFont())
                .foregroundColor(.white)
                .padding(.bottom, 20)
            
            Spacer()
        }
    }
    
    // MARK: - 중간 title 영역
    
    func title() -> some View {
        Text(props.popupTitle)
            .font(Fonts.heading2Bold.toFont())
            .foregroundColor(Colors.Label.Normal.strong)
            .padding(.bottom, 12)
    }
    
    func subTitle() -> some View {
        Text(props.popupContent)
            .multilineTextAlignment(.center)
            .font(Fonts.heading3Medium.toFont())
            .foregroundColor(Colors.Label.Normal.neutral)
            .padding(.bottom, 24)
    }
    
    // MARK: - 하단 버튼 영역
    
    func viewButton() -> some View {
        Button(action: onTapPost) {
            Text("포스트 보러 가기")
                .font(Fonts.heading2Bold.toFont())
                .foregroundStyle(.white)
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .background(Colors.Primary.normal)
                .cornerRadius(20)
        }
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
        .contentShape(Rectangle())
        .background(.clear)
        .padding(.bottom, 20)
    }
}
