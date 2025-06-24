//
//  StarRatingView.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 6/25/25.
//

import SwiftUI

struct StarRatingView: View {
    let rating: Double
    let maxRating = 5

    var body: some View {
        HStack(spacing: 2) {
            ForEach(0 ..< maxRating, id: \.self) { index in
                let current = Double(index)
                if rating >= current + 1 {
                    Image("star_full")
                } else if rating >= current + 0.5 {
                    Image("star_half")
                } else {
                    Image("star_empty")
                }
            }
        }
    }
}
