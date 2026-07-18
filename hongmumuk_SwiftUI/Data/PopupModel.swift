//
//  PopupModel.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 7/14/26.
//
import Foundation

struct HMPopupProps {
    let weekLabel: String
    let subtitle: String
    let title: String
    let coverUrl: String
    let popupTitle: String
    let popupContent: String
}

struct HMPopupItem: Identifiable {
    let id: String
    let image: String
    let placeName: String
    let category: String
    let contentTitle: String
    let content: String
    let displayOrder: Int
}
