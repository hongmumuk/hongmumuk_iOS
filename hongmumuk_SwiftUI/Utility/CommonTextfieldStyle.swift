//
//  CommonTextfieldStyle.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 2/28/25.
//

import Foundation
import SwiftUI

public enum CommonTextFieldStyle {
    public static func backgroundColor(isFocused: Bool, isEmpty: Bool, isValid: Bool, loginError: LoginError?) -> Color {
        if isFocused { return Colors.GrayScale.grayscale5 }
        if isEmpty { return Colors.GrayScale.grayscale5 }
        if loginError != nil { return Colors.SemanticColor.negative10 }
        return isValid ? Colors.GrayScale.grayscale5 : Colors.SemanticColor.negative10
    }
    
    public static func borderColor(isFocused: Bool, isEmpty: Bool, isValid: Bool, loginError: LoginError?) -> Color {
        if isFocused { return Colors.Primary.normal }
        if isEmpty { return Colors.Border.strong }
        if loginError != nil { return Colors.SemanticColor.negative }
        return isValid ? Colors.Border.strong : Colors.SemanticColor.negative
    }
    
    public static func textColor(isFocused: Bool, isEmpty: Bool, isValid: Bool, loginError: LoginError?) -> Color {
        if isFocused { return Colors.GrayScale.normal }
        if isEmpty { return Colors.GrayScale.normal }
        if loginError != nil { return Colors.SemanticColor.negative }
        return isValid ? Colors.GrayScale.normal : Colors.SemanticColor.negative
    }
}
