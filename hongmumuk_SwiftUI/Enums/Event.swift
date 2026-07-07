import Firebase
import Foundation

enum Event {
    // MARK: - Screen

    case screenHome
    case screenPartner
    case screenDetail(placeId: String, placeName: String, category: String)

    // MARK: - Home

    case homeCardTapped(placeId: String, placeName: String, section: String)
    case homeCategoryFilterSelected(category: String)

    // MARK: - Partner

    case partnerCardTapped(placeId: String, placeName: String, category: String)
    case partnerCategoryFilterSelected(category: String)
}

extension Event {
    var name: String {
        switch self {
        case .screenHome: return "screen_home"
        case .screenPartner: return "screen_partner"
        case .screenDetail: return "screen_detail"
        case .homeCardTapped: return "home_card_tapped"
        case .homeCategoryFilterSelected: return "home_category_filter_selected"
        case .partnerCardTapped: return "partner_card_tapped"
        case .partnerCategoryFilterSelected: return "partner_category_filter_selected"
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .screenHome, .screenPartner:
            return nil
        case let .screenDetail(placeId, placeName, category):
            return ["place_id": placeId, "place_name": placeName, "category": category]
        case let .homeCardTapped(placeId, placeName, section):
            return ["place_id": placeId, "place_name": placeName, "section": section]
        case let .homeCategoryFilterSelected(category):
            return ["category": category]
        case let .partnerCardTapped(placeId, placeName, category):
            return ["place_id": placeId, "place_name": placeName, "category": category]
        case let .partnerCategoryFilterSelected(category):
            return ["category": category]
        }
    }

    func send() {
        Analytics.logEvent(name, parameters: parameters)
    }
}
