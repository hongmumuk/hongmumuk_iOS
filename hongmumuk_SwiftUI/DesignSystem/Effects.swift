//
//  Effects.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 2/2/25.
//

import Foundation
import SwiftUI

enum Effects {
    enum Shadows {
        static let normal = ShadowStyle(shadows: [
            ShadowEffect(color: .black.opacity(0.12), radius: 2, x: 0, y: 1),
            ShadowEffect(color: .black.opacity(0.08), radius: 1, x: 0, y: 0),
            ShadowEffect(color: .black.opacity(0.08), radius: 1, x: 0, y: 0)
        ])
        
        static let emphasize = ShadowStyle(shadows: [
            ShadowEffect(color: .black.opacity(0.12), radius: 8, x: 0, y: 2),
            ShadowEffect(color: .black.opacity(0.08), radius: 4, x: 0, y: 1),
            ShadowEffect(color: .black.opacity(0.08), radius: 1, x: 0, y: 0)
        ])
        
        static let strong = ShadowStyle(shadows: [
            ShadowEffect(color: .black.opacity(0.12), radius: 12, x: 0, y: 6),
            ShadowEffect(color: .black.opacity(0.08), radius: 8, x: 0, y: 4),
            ShadowEffect(color: .black.opacity(0.08), radius: 4, x: 0, y: 0)
        ])
        
        static let heavy = ShadowStyle(shadows: [
            ShadowEffect(color: .black.opacity(0.12), radius: 20, x: 0, y: 16),
            ShadowEffect(color: .black.opacity(0.08), radius: 16, x: 0, y: 8),
            ShadowEffect(color: .black.opacity(0.08), radius: 8, x: 0, y: 0)
        ])
    }
}

struct ShadowEffect {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

struct ShadowStyle {
    let shadows: [ShadowEffect]
}
