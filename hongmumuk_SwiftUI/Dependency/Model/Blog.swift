//
//  Blog.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/22/25.
//

import Foundation

struct Blog: Codable, Equatable, Identifiable {
    var id = UUID().uuidString
    var url: String
    var title: String
    var subtitle: String
    var date: String
    var owner: String
}
