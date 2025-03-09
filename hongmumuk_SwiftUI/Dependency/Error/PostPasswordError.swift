//
//  PostPasswordError.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 3/9/25.
//

import Foundation

enum PostPasswordError: String, Error {
    case unknown
    case duplicate = "BAD400_7"
}
