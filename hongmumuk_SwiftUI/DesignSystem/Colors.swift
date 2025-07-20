//
//  Colors.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 2/2/25.
//

import Foundation
import SwiftUI

enum Colors {
    enum Primary {
        static let normal = Color(hex: "#193BE6")
        static let alternative = Color(hex: "FAFBFE")
        static let strong = Color(hex: "#1735CF")
        static let heavy = Color(hex: "#142FB8")
        
        static let primary5 = Color(hex: "#FAFBFE")
        static let primary10 = Color(hex: "#E8EBFC")
        static let primary20 = Color(hex: "#A3B1F5")
        static let primary30 = Color(hex: "#758AF0")
        static let primary40 = Color(hex: "#758AF0")
        static let primary45 = Color(hex: "#758AF0")
        static let primary50 = Color(hex: "#304FE8")
        
        static let primary55 = Color(hex: "#193BE6")
        static let primary60 = Color(hex: "#1735CF")
        static let primary70 = Color(hex: "#142FB8")
        static let primary80 = Color(hex: "#0F248A")
        static let primary90 = Color(hex: "#0A185C")
        static let primary95 = Color(hex: "#050C2E")
    }
    
    enum GrayScale {
        static let normal = Color(hex: "#040615")
        static let neutral = Color(hex: "#2B2D3B")
        static let alternative = Color(hex: "#8F92A3")
        static let assistive = Color(hex: "#C7C9D1")
        static let disable = Color(hex: "#E2E3E9")
        
        static let grayscale5 = Color(hex: "#FAFBFE")
        static let grayscale10 = Color(hex: "#EFF0F5")
        static let grayscale20 = Color(hex: "#E2E3E9")
        static let grayscale30 = Color(hex: "#E2E3E9")
        static let grayscale40 = Color(hex: "#ABADBA")
        static let grayscal45 = Color(hex: "#8F92A3")
        static let grayscale50 = Color(hex: "#73778C")
        
        static let grayscale55 = Color(hex: "#5C5F70")
        static let grayscale60 = Color(hex: "#434656")
        static let grayscale65 = Color(hex: "#303241")
        static let grayscale70 = Color(hex: "#2B2D3B")
        static let grayscale90 = Color(hex: "#111322")
        static let grayscale95 = Color(hex: "#040615")
    }
    
    enum Border {
        static let normal = Color(hex: "#040615").opacity(0.1)
        static let neutral = Color(hex: "#040615").opacity(0.07)
        static let alternative = Color(hex: "#040615").opacity(0.05)
        static let strong = Color(hex: "#040615").opacity(0.15)
    }
    
    enum Label {
        static let white = Color(hex: "#FFFFFF")
        static let black = Color(hex: "#000000")
    }
    
    enum SemanticColor {
        static let positive = Color(hex: "#20DF7F")
        static let negative = Color(hex: "#FF4433")
        
        static let positive0 = Color(hex: "#FFFFFF")
        static let positive5 = Color(hex: "#FBFEFC")
        static let positive10 = Color(hex: "#E9FCF2")
        static let positive20 = Color(hex: "#D2F9E5")
        static let positive30 = Color(hex: "#A6F2CC")
        static let positive40 = Color(hex: "#79ECB2")
        static let positive45 = Color(hex: "#4CE599")
        
        static let positive50 = Color(hex: "#36E28C")
        static let positive60 = Color(hex: "#1DC973")
        static let positive70 = Color(hex: "#19B366")
        static let positive80 = Color(hex: "#13864C")
        static let positive90 = Color(hex: "#0D5933")
        static let positive95 = Color(hex: "#062D19")
        
        static let negative5 = Color(hex: "#FFFAFA")
        static let negative10 = Color(hex: "#FFE8E5")
        static let negative20 = Color(hex: "#FFD0CC")
        static let negative30 = Color(hex: "#FFA199")
        static let negative40 = Color(hex: "#FF7366")
        static let negative45 = Color(hex: "#FF4433")
        static let negative50 = Color(hex: "#FF2D1A")
        
        static let nagative55 = Color(hex: "#FF1500")
        static let nagative60 = Color(hex: "#E51300")
        static let nagative70 = Color(hex: "#CC1100")
        static let nagative80 = Color(hex: "#990D00")
        static let nagative90 = Color(hex: "#660900")
        static let nagative95 = Color(hex: "#330400")
    }
}
