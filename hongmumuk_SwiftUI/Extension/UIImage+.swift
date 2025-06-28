//
//  UIImage+.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 6/28/25.
//

import SwiftUI

extension UIImage {
    func resized(to newSize: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: newSize).image { _ in
            draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
