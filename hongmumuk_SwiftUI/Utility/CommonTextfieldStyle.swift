//
//  CommonTextfieldStyle.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 2/28/25.
//

import Foundation
import SwiftUI

public enum CommonTextFieldStyle {
    public static func backgroundColor(for state: TextFieldState) -> Color {
        switch state {
        case .focused, .empty, .valid:
            return Colors.GrayScale.grayscale5
        case .loginError, .invalid, .codeInvalid:
            return Colors.SemanticColor.negative10
        case .codeVerified:
            return Colors.SemanticColor.positive10
        default:
            return Colors.GrayScale.grayscale5
        }
    }

    public static func borderColor(for state: TextFieldState) -> Color {
        switch state {
        case .focused:
            return Colors.Primary.normal
        case .empty, .valid:
            return Colors.Border.strong
        case .loginError, .invalid, .codeInvalid:
            return Colors.SemanticColor.negative
        case .codeVerified:
            return Colors.SemanticColor.positive
        case .normal:
            return Colors.Border.strong
        }
    }

    public static func textColor(for state: TextFieldState) -> Color {
        switch state {
        case .focused, .empty, .valid:
            return Colors.GrayScale.normal
        case .loginError, .invalid, .codeInvalid:
            return Colors.SemanticColor.negative
        case .codeVerified:
            return Colors.SemanticColor.positive
        case .normal:
            return Colors.GrayScale.normal
        }
    }
}
