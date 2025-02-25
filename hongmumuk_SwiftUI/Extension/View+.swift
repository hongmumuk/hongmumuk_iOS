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
