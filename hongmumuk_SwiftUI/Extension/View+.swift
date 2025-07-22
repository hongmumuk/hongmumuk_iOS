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
