//
//  Theme.swift
//  Asala
//
//  Created by Omar Seyfetdinov on 05/09/2025.
//

import SwiftUI

enum Theme {
    static let bg        = Color(red: 10/255, green: 20/255, blue: 60/255)
    static let panel     = Color(red: 16/255, green: 22/255, blue: 56/255)
    static let sidebar   = Color(red: 8/255,  green: 8/255,  blue: 16/255)
    static let border    = Color.white.opacity(0.18)
    static let text      = Color.white
    static let accent    = Color(red: 248/255, green: 210/255, blue: 71/255)
    static let xpGreen   = Color(red: 98/255,  green: 197/255, blue: 73/255)
    static let heartPink = Color(red: 253, green: 144,  blue: 196)

    static let pixelFontName = "PressStart2P-Regular"
    static func pixel(_ size: CGFloat) -> Font {
        if UIFont(name: pixelFontName, size: size) != nil {
            return .custom(pixelFontName, size: size)
        } else {
            return .system(size: size, weight: .heavy, design: .monospaced)
        }
    }

    static func cardStroke(corner: CGFloat = 18) -> some View {
        RoundedRectangle(cornerRadius: corner)
            .stroke(Theme.border, lineWidth: 1)
    }
}
