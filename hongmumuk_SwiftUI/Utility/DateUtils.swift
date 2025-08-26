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
        
        // 오늘
        if days == 0 {
            return "date_today".localized()
        }
        
        // 1일전~3일전
        if days >= 1 && days <= 3 {
            return "date_days_ago".localized(variables: days) // "%d일전"
        }
        
        // 4일전~같은 해
        let currentYear = calendar.component(.year, from: now)
        let reviewYear = calendar.component(.year, from: date)
        
        if reviewYear == currentYear {
            let formatter = DateFormatter()
            formatter.dateFormat = "date_this_year".localized() // "MM.dd"
            formatter.locale = Locale.current
            return formatter.string(from: date)
        }
        
        // 이전 해
        let formatter = DateFormatter()
        formatter.dateFormat = "date_other_year".localized() // "yy.MM.dd"
        formatter.locale = Locale.current
        return formatter.string(from: date)
    }
}
