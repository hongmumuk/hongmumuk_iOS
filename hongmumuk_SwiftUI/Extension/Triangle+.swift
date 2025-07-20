//
//  Triangle+.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 7/19/25.
//

import Foundation
import SwiftUI

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // 더 자연스러운 화살표 모양을 위해 중앙점을 약간 위로 조정
        let centerX = rect.midX
        let topY = rect.minY + 2 // 약간의 여백
        let bottomLeftX = rect.minX + 2
        let bottomRightX = rect.maxX - 2
        let bottomY = rect.maxY - 2

        path.move(to: CGPoint(x: centerX, y: topY))
        path.addLine(to: CGPoint(x: bottomRightX, y: bottomY))
        path.addLine(to: CGPoint(x: bottomLeftX, y: bottomY))
        path.closeSubpath()

        return path
    }
}
