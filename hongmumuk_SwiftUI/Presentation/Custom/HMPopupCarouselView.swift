//
//  HMPopupCarouselView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 7/19/26.
//

import Kingfisher
import SwiftUI

struct HMPopupCarouselView: View {
    let items: [HMPopupItem]
    let onClose: () -> Void
    
    @State private var currentPage: Int = 0
    
    private var totalPages: Int { items.count + 1 }
    
    var body: some View {
        mainContent()
    }
    
    func mainContent() -> some View {
        pageTabView()
            .overlay(content: overlayContent)
            .padding(.horizontal, 24)
    }
    
    // MARK: - TabView
    
    func pageTabView() -> some View {
        TabView(selection: $currentPage) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                itemPage(item: item)
                    .tag(index)
            }
            
            HMPopupLastView(onTapPost: onClose)
                .tag(items.count)
        }
        .clipShape(RoundedRectangle(cornerRadius: 32))
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: 440)
        .blockScrollBounce()
    }
    
    func itemPage(item: HMPopupItem) -> some View {
        GeometryReader { geometry in
            KFImage(URL(string: item.image))
                .setProcessor(
                    DownsamplingImageProcessor(
                        size: CGSize(
                            width: geometry.size.width * UIScreen.main.scale,
                            height: 440 * UIScreen.main.scale
                        )
                    )
                )
                .scaleFactor(UIScreen.main.scale)
                .cacheOriginalImage()
                .resizable()
                .scaledToFill()
                .frame(width: geometry.size.width, height: 440)
                .clipShape(RoundedRectangle(cornerRadius: 32))
        }
        .frame(height: 440)
    }
    
    // MARK: - 오버레이 (버튼 + 페이지네이션)
    
    func overlayContent() -> some View {
        VStack {
            topStack()
            Spacer()
            bottomStack()
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: - 닫기 버튼
    
    func topStack() -> some View {
        HStack(alignment: .top) {
            paginationLabel()
            Spacer()
            closeButton()
        }
        .padding(.top, 20)
    }
    
    func paginationLabel() -> some View {
        Text("\(currentPage + 1)/\(totalPages)")
            .font(Fonts.body2Medium.toFont())
            .foregroundStyle(Colors.Label.Normal.assisitive)
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .background(Colors.Decorate.Scrim.normal.opacity(0.6))
            .clipShape(Capsule())
    }
    
    func closeButton() -> some View {
        Button(action: onClose) {
            Image(systemName: "xmark")
                .resizable()
                .scaledToFit()
                .frame(width: 10, height: 10)
                .foregroundStyle(Colors.Label.Normal.assisitive)
        }
        .frame(width: 32, height: 32)
        .background(Colors.Decorate.Scrim.normal.opacity(0.6))
        .clipShape(Circle())
    }
    
    // MARK: - 페이지네이션
    
    func bottomStack() -> some View {
        paginationDots()
            .padding(.bottom, 18)
    }

    func paginationDots() -> some View {
        HStack(spacing: 4) {
            ForEach(0 ..< totalPages, id: \.self) { index in
                Capsule()
                    .fill(Color.white)
                    .frame(width: index == currentPage ? 28 : 6, height: 6)
                    .opacity(index == currentPage ? 1 : 0.5)
                    .animation(.spring(response: 0.3, dampingFraction: 0.8), value: currentPage)
            }
        }
    }
}
