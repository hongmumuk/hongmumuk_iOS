//
//  TextFieldState.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/10/25.
//

import Foundation

enum TextFiledState: Equatable {
    case none
    case valid
    case validGreen(String)
    case invalid(String)
    case focused
}
