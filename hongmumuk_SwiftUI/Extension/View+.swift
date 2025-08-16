//
//  View+.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 2/2/25.
//

import SwiftUI

extension View {
    func applyShadows(_ style: ShadowStyle) -> some View {
        style.shadows.reduce(AnyView(self)) { view, shadow in
            AnyView(view.shadow(
                color: shadow.color,
                radius: shadow.radius,
                x: shadow.x,
                y: shadow.y
            ))
        }
    }
}

struct FontStyleModifier: ViewModifier {
    let fontStyle: FontStyle
    
    func body(content: Content) -> some View {
        content
            .font(fontStyle.toFont())
            .lineSpacing(fontStyle.lineHeight - fontStyle.size)
            .tracking(fontStyle.letterSpacing)
    }
}

extension View {
    func fontStyle(_ fontStyle: FontStyle) -> some View {
        modifier(FontStyleModifier(fontStyle: fontStyle))
    }
}

#if canImport(UIKit)
    extension View {
        /// 빈 부분을 탭하면 키보드가 사라지도록 뷰에 붙여주는 헬퍼
        func dismissKeyboardOnTap() -> some View {
            contentShape(Rectangle()) // 빈 공간 전체를 터치 가능하게
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                                    to: nil, from: nil, for: nil)
                }
        }
    }
#endif

private struct HideTabBarModifier: ViewModifier {
    let hidden: Bool
    let restoreOnDisappear: Bool

    func body(content: Content) -> some View {
        content
            .onAppear {
                UITabBar.appearance().isHidden = hidden
            }
            .onChange(of: hidden) { newValue in
                UITabBar.appearance().isHidden = newValue
            }
            .onDisappear {
                if restoreOnDisappear { UITabBar.appearance().isHidden = false }
            }
    }
}

extension View {
    /// 현재 뷰가 나타나는 동안만 UITabBar를 숨깁니다.
    /// - Parameters:
    ///   - hidden: 숨길지 여부 (기본값 true)
    ///   - restoreOnDisappear: 사라질 때 원복할지 여부 (기본값 true)
    func hideTabBar(_ hidden: Bool = true, restoreOnDisappear: Bool = true) -> some View {
        modifier(HideTabBarModifier(hidden: hidden, restoreOnDisappear: restoreOnDisappear))
    }
}
