//
//  Keyword.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/24/25.
//

import Foundation

// enum Keyword: String, CaseIterable {
//    case honbap = "혼밥"
//    case hongdaeStudent = "홍대생"
//    case matjip = "맛집"
//    case sumeun = "숨은"
//    case sangsu = "상수"
//    case yeonnamDong = "연남동"
//    case hotple = "핫플"
//    case atmosphere = "분위기좋은"
//    case gasungbi = "가성비"
//    case date = "데이트"
//    case suljip = "술집"
//    case sulanju = "술안주"
//    case localMatjip = "로컬맛집"
//    case instaGamsung = "인스타감성"
//    case waiting = "웨이팅"
//    case brunch = "브런치"
//    case recommendation = "추천"
//    case honsul = "혼술"
//    case dangaol = "단골"
//    case pujumhan = "푸짐한"
//    case spicy = "매운맛"
//    case specialMenu = "특별한메뉴"
//    case twentyFourHours = "24시간"
// }

enum Keyword: String, CaseIterable {
    case honbap
    case hongdaeStudent
    case matjip
    case sumeun
    case sangsu
    case yeonnamDong
    case hotple
    case atmosphere
    case gasungbi
    case date
    case suljip
    case sulanju
    case localMatjip
    case instaGamsung
    case waiting
    case brunch
    case recommendation
    case honsul
    case dangaol
    case pujumhan
    case spicy
    case specialMenu
    case twentyFourHours
}

// Keyword를 확장하여 한국어 값 속성 추가
extension Keyword {
    var koreanValue: String {
        switch self {
        case .honbap: return "혼밥"
        case .hongdaeStudent: return "홍대생"
        case .matjip: return "맛집"
        case .sumeun: return "숨은"
        case .sangsu: return "상수"
        case .yeonnamDong: return "연남동"
        case .hotple: return "핫플"
        case .atmosphere: return "분위기 좋은"
        case .gasungbi: return "가성비"
        case .date: return "데이트"
        case .suljip: return "술집"
        case .sulanju: return "술안주"
        case .localMatjip: return "로컬맛집"
        case .instaGamsung: return "인스타감성"
        case .waiting: return "웨이팅"
        case .brunch: return "브런치"
        case .recommendation: return "추천"
        case .honsul: return "혼술"
        case .dangaol: return "단골"
        case .pujumhan: return "푸짐한"
        case .spicy: return "매운맛"
        case .specialMenu: return "특별한 메뉴"
        case .twentyFourHours: return "24시간"
        }
    }
}
