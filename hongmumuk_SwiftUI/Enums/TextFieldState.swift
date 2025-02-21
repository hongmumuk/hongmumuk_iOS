//
//  TextFieldState.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/10/25.
//

import Foundation
import SwiftUI

enum TextFieldStatus {
    case `default`
    case focused
    case invalid
    case valid
}

struct TextFieldState: Equatable {
    var text: String = ""
    var status: TextFieldStatus = .default
    var errorMessage: String? = nil

    mutating func updateStatus(isFocused: Bool, isValid: Bool, message: String? = nil) {
        if isFocused {
            if status == .invalid {
                return
            } else {
                status = .focused
            }
        } else {
            status = isValid ? .valid : .invalid
            errorMessage = isValid ? nil : message
        }
    }
    
    var backgroundColor: Color {
        switch status {
        case .default, .focused, .valid:
            return Color(hex: "FBFBFE")
        case .invalid:
            return Color(hex: "FFE8E5")
        }
    }
    
    var borderColor: Color {
        switch status {
        case .default, .valid:
            return Colors.Border.strong
        case .focused:
            return Colors.Primary.normal
        case .invalid:
            return Colors.SemanticColor.negative
        }
    }
    
    var textColor: Color {
        switch status {
        case .default, .focused, .valid:
            return Colors.GrayScale.normal
        case .invalid:
            return Colors.SemanticColor.negative
        }
    }
}
