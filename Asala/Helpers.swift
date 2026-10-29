//
//  Helpers.swift
//  Asala
//
//  Created by Omar Seyfetdinov on 03/10/2025.
//

import SwiftUI

func hatScale(for imageName: String) -> CGFloat {
    switch imageName {
    case "beanie": return 0.32
    case "sprout": return 0.35
    case "sunhat": return 0.40
    case "bdayHat": return 0.38
    case "topHat": return 0.35
    case "sunglasses": return 0.40
    default: return 0.42
    }
}

func hatYOffset(for imageName: String, perryWidth: CGFloat) -> CGFloat {
    let base = -perryWidth * 0.28
    switch imageName {
    case "beanie": return base - 40
    case "sunhat": return base - 40
    case "topHat": return base - 60
    case "bdayHat": return base - 55
    case "sunglasses": return base + 2
    case "sprout": return base - 55
    default: return base
    }
}
