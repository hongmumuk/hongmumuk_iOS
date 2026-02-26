import Foundation

struct DetailModel: Decodable {
    let id: String
    let placeName: String?
    let title: String?
    let contentTitle: String?
    let content: String?
    let photos: [DetailPhoto]?
    let category: String?
    let address: String?
    let walkTime: String?
    let viewCount: Int?
    let menus: [DetailMenu]?
    let tags: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case placeName = "place_name"
        case title
        case contentTitle = "content_title"
        case content
        case photos
        case category
        case tags
        case address
        case walkTime = "walk_time"
        case viewCount = "view_count"
        case menus
    }
}

struct DetailPhoto: Decodable, Identifiable {
    let url: String
    let sortOrder: Int
    
    var id: String { "\(url)-\(sortOrder)" }
    
    enum CodingKeys: String, CodingKey {
        case url
        case sortOrder = "sort_order"
    }
}

struct DetailMenu: Decodable, Identifiable {
    let name: String
    let price: Int?
    
    var id: String { name }
}
