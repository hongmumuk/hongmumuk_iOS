import Foundation
import SwiftUI

protocol HM: Identifiable {
    var id: UUID { get }
    var type: HMLType { get }
}

enum HMLType {
    case title
    case largePhoto
    case mediumPhoto
    case tagSmallPhoto
    case categorySmallPhoto
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

protocol HMSmallPhoto: Identifiable {
    var id: UUID { get }
    var imageUrl: String { get }
    var title: String { get }
}

struct HMTagSmallPhotos: HM {
    var id: UUID = .init()
    var type: HMLType = .tagSmallPhoto
    var items: [any HMSmallPhoto]
}

struct HMTagSmallPhoto: HMSmallPhoto {
    let id = UUID()
    let title: String
    let tags: [String]
    let category: Category
    let distance: Int
    let imageUrl: String
}

struct HMCategorySmallPhotos: HM {
    var id: UUID = .init()
    var type: HMLType = .categorySmallPhoto
    var items: [any HMSmallPhoto]
}

struct HMCategorySmallPhoto: HMSmallPhoto {
    let id = UUID()
    let title: String
    let tag: String
    let category: Category
    let distance: Int
    let imageUrl: String
}

struct HMBeniftSmallPhoto: HMSmallPhoto {
    let id = UUID()
    let title: String
    let subTitle: String
    let tag: String
    let address: String
    let imageUrl: String
}
