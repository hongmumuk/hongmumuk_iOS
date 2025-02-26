//
//  KeywordClient.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/24/25.
//

import Dependencies

struct KeywordClient {
    var extractKeywords: (_ review: String) -> [String]
}

extension KeywordClient: DependencyKey {
    static var liveValue = KeywordClient.init { review in
        return Keyword.allCases
            .map { KeywordCount(keyword: $0, count: review.countOccurrences(of: $0)) }
            .sorted { $0.count > $1.count }
            .map(\.keyword.rawValue)
    }
}

struct KeywordCount {
    let keyword: Keyword
    let count: Int
}

extension DependencyValues {
    var keywordClient: KeywordClient {
        get { self[KeywordClient.self] }
        set { self[KeywordClient.self] = newValue }
    }
}
