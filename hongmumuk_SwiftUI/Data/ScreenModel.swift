import Foundation

struct DetailModel: Decodable {
    let content: ContentDetail
    let place: Place?
    let menus: [Menu]?
    let tags: [String]
}

struct ContentDetail: Decodable, Identifiable {
    let id: String
    let mainTitle: String
    let subTitle: String?
    let description: String?
    let addressText: String?
    let walkTimeMin: Int?
    let heroImageUrl: String?
    let detailImageUrls: [String]?
    let flags: [String: Bool]?

    enum CodingKeys: String, CodingKey {
        case id
        case mainTitle = "main_title"
        case subTitle = "sub_title"
        case description
        case addressText = "address_text"
        case walkTimeMin = "walk_time_min"
        case heroImageUrl = "hero_image_url"
        case detailImageUrls = "detail_image_urls"
        case flags
    }
}

struct Place: Decodable {
    let name: String?
    let address: String?
    let phone: String?
    let businessHours: String?

    enum CodingKeys: String, CodingKey {
        case name
        case address
        case phone
        case businessHours = "business_hours"
    }
}

struct Menu: Decodable, Identifiable {
    var id: String { name }

    let name: String
    let price: Int?
    let imageUrl: String?
    let isRecommended: Bool?

    enum CodingKeys: String, CodingKey {
        case name
        case price
        case imageUrl = "image_url"
        case isRecommended = "is_recommended"
    }
}
