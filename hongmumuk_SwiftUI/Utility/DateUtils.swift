//
//  DateUtils.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 6/25/25.
//

import Foundation

enum DateUtils {
    static func parse(from string: String, format: String = "yyyy.MM.dd") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.date(from: string)
    }

    static func formattedReviewDate(from dateString: String) -> String {
        guard let date = parse(from: dateString) else { return dateString }
        let now = Date()
        let calendar = Calendar.current

        guard let days = calendar.dateComponents([.day], from: date, to: now).day else {
            return dateString
        }

        // TODO: 로컬라이즈드
        switch days {
        case 0: return "오늘"
        case 1 ... 6: return "\(days)일 전"
        case 7: return "일주일 전"
        default:
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            formatter.locale = Locale(identifier: "ko_KR")
            return formatter.string(from: date)
        }
    }
}
