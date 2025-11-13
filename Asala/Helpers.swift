//
//  Helpers.swift
//  Asala
//
//  Created by Omar Seyfetdinov on 03/10/2025.
//

import SwiftUI

func hatScale(for imageName: String) -> CGFloat {
    switch imageName {
    case "beanie": return 0.42
    case "sprout": return 0.35
    case "sunhat": return 0.52
    case "bdayHat": return 0.38
    case "topHat": return 0.46
    case "sunglasses": return 0.46
    default: return 0.42
    }
}

func hatYOffset(for imageName: String, perryWidth: CGFloat) -> CGFloat {
    let base = -perryWidth * 0.28
    switch imageName {
    case "sunhat": return base - 18
    case "topHat": return base - 14
    case "bdayHat": return base - 8
    case "sunglasses": return base + 2
    case "sprout": return base - 6
    default: return base
    }
}
