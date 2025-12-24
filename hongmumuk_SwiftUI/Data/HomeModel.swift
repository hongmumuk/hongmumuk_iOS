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
    
    enum CodingKeys: String, CodingKey {
        case title
        case cardStyle = "card_style"
        case cardVariant = "card_variant"
        case show
    }
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
    case viewCount = "view_count"
    case subTitle = "sub_title"
    case category
    case walkTime = "walk_time"
}

struct HomeItem: Decodable, Identifiable {
    let id: String
    let mainTitle: String
    let subTitle: String?
    let heroImageUrl: String?
    let detailImageUrls: [String]?
    let cuisineType: String?
    let walkTimeMin: Int?
    let viewCount: Int?
    let flags: [String: Bool]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case mainTitle = "main_title"
        case subTitle = "sub_title"
        case heroImageUrl = "hero_image_url"
        case detailImageUrls = "detail_image_urls"
        case cuisineType = "cuisine_type"
        case walkTimeMin = "walk_time_min"
        case viewCount = "view_count"
        case flags
    }
}
