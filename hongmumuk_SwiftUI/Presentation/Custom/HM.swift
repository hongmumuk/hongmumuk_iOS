import Foundation

protocol HM: Identifiable {
    var id: UUID { get }
    var type: HMLType { get }
}

enum HMLType {
    case title
    case largePhoto
    case mediumPhoto
}

struct HMLTitle: HM {
    let id: UUID = .init()
    let type: HMLType = .title
    let title: String
}

struct HMLagePhotos: HM {
    var id: UUID = .init()
    var type: HMLType = .largePhoto
    var items: [HMLagePhoto]
}

struct HMLagePhoto: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let category: Category
    let views: Int
    let distance: Int
    let imageUrl: String
}

struct HMMediumPhotos: HM {
    var id: UUID = .init()
    var type: HMLType = .mediumPhoto
    var items: [HMMediumPhoto]
}

struct HMMediumPhoto: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let views: Int
    let imageUrl: String
}
