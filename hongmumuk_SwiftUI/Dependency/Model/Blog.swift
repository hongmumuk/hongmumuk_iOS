//
//  Blog.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/22/25.
//

import Foundation

struct Blog: Codable, Equatable, Identifiable {
    var id: Int
    var url: String
    var title: String
    var subtitle: String
    var date: String
    var owner: String

    enum CodingKeys: String, CodingKey {
        case id
        case url
        case title
        case subtitle = "subTitle"
        case date = "postDate"
        case owner = "bloggerName"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        url = try container.decode(String.self, forKey: .url)
        date = try container.decode(String.self, forKey: .date)
        owner = try container.decode(String.self, forKey: .owner)
        
        let rawTitle = try container.decode(String.self, forKey: .title)
        title = rawTitle.removingHTMLTags
        
        let rawSubtitle = try container.decode(String.self, forKey: .subtitle)
        subtitle = rawSubtitle.removingHTMLTags
    }
    
    init(
        id: Int,
        url: String,
        title: String,
        subtitle: String,
        date: String,
        owner: String
    ) {
        self.id = id
        self.url = url
        self.title = title.removingHTMLTags
        self.subtitle = subtitle.removingHTMLTags
        self.date = date
        self.owner = owner
    }
}
