import Foundation

struct ScreenModel: Decodable {
    let screenKey: String
    let specVersion: Int
    let sections: [Section]

    enum CodingKeys: String, CodingKey {
        case screenKey = "screen_key"
        case specVersion = "spec_version"
        case sections
    }
}

struct Section: Decodable, Identifiable {
    var id: String { sectionKey }

    let sectionKey: String
    let displayOrder: Int
    let type: SectionType
    let props: SectionProps
    let items: [HomeItem]

    enum CodingKeys: String, CodingKey {
        case sectionKey = "section_key"
        case displayOrder = "display_order"
        case type
        case props
        case items
    }
}

enum SectionType: String, Decodable {
    case cards
    case categoryFilterList = "category_filter_list"
}

struct SectionProps: Decodable {
    let title: String?

    let cardStyle: CardStyle?
    let cardVariant: CardVariant?
    let show: [SectionShowItem]?

    let chips: [CategoryChip]?
    let chipField: String?
    let defaultChip: String?

    enum CodingKeys: String, CodingKey {
        case title
        case cardStyle = "card_style"
        case cardVariant = "card_variant"
        case show
        case chips
        case chipField = "chip_field"
        case defaultChip = "default_chip"
    }
}

struct CategoryChip: Decodable, Identifiable {
    let key: String
    let label: String

    var id: String { key }
}

enum CardStyle: String, Decodable {
    case large
    case medium
    case small
}

enum CardVariant: String, Decodable {
    case `default`
    case tag
    case flag
    case partner
}

enum SectionShowItem: String, Decodable {
    case image
    case title
    case subtitle
    case category
    case placeName = "place_name"
    case address

    case walkTime = "walk_time"
    case viewCount = "view_count"
    case tags
    case badge
    
    case partnerCategoryLabel = "partner_category_label"
    case partnerSubcategoryLabel = "partner_subcategory_label"
}

struct HomeItem: Decodable, Identifiable {
    let id: String

    let title: String?
    let subtitle: String?
    let image: String?

    let placeName: String?
    let category: String?
    let primaryCategoryKey: String?

    let address: String?
    let partnerCategoryKey: String?
    let partnerCategoryLabel: String?
    let partnerSubcategoryLabel: String?

    let tags: [String]?
    let viewCount: Int?
    let walkTimeMin: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case subtitle
        case image
        case placeName = "place_name"
        case category
        case primaryCategoryKey = "primary_category_key"

        case address
        case partnerCategoryKey = "partner_category_key"
        case partnerCategoryLabel = "partner_category_label"
        case partnerSubcategoryLabel = "partner_subcategory_label"

        case tags
        case viewCount = "view_count"
        case walkTimeMin = "walk_time_min"
    }
}
