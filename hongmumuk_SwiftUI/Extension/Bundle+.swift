//
//  Bundle+.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 3/6/25.
//

import Foundation

extension Bundle {
    var fullVersion: String {
        guard let version = infoDictionary?["CFBundleShortVersionString"] as? String else {
            return "0.0.0"
        }
        let versionComponents = version.split(separator: ".")
        let major = versionComponents.count > 0 ? versionComponents[0] : "0"
        let minor = versionComponents.count > 1 ? versionComponents[1] : "0"
        let patch = versionComponents.count > 2 ? versionComponents[2] : "0"
        return "\(major).\(minor).\(patch)"
    }
}
