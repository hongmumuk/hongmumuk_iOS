import Foundation

enum Category: String, CaseIterable, Codable {
    case all
    case korean
    case chinese
    case japanese
    case cafe
    case fastfood
    
    case dining
    case culture
    case edu
    case shopping
    case health
    case beauty
}

extension Category {
    var displayName: String {
        switch self {
        case .all: return "전체"
        case .korean: return "한식"
        case .chinese: return "중식"
        case .japanese: return "일식"
        case .cafe: return "카페"
        case .fastfood: return "패스트푸드"

        case .dining: return "외식"
        case .culture: return "문화"
        case .edu: return "교육"
        case .shopping: return "쇼핑"
        case .health: return "운동"
        case .beauty: return "미용"
        }
    }
    
    var lineIconName: String {
        switch self {
        case .korean, .chinese:
            "riceLine"
        case .japanese:
            "japanLine"
        case .cafe:
            "cafeLine"
        case .fastfood:
            "fastFoodLine"
        default:
            ""
        }
    }
    
    static func filterHome() -> [Category] {
        return [.korean, .chinese, .japanese, .cafe, .fastfood]
    }
    
    static func filterPartner() -> [Category] {
        return [.all, .dining, .culture, .edu, .shopping, .health, .beauty]
    }
}
    
