import Foundation

enum Category: String, CaseIterable, Codable {
    case all
    case korean
    case chinese
    case japanese
    case cafe
    case fastfood
    case food
    case life
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
        case .food: return "음식점"
        case .life: return "생활/문화"
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
        return allCases.filter { category in
            return category != .life && category != .food
        }
    }
    
    static func filterPartner() -> [Category] {
        return allCases.filter { category in
            return category == .life || category == .food || category == .cafe || category == .all
        }
    }
}
    