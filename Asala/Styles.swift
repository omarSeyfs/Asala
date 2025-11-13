//
//  Styles.swift
//  Asala
//
//  Created by Omar Seyfetdinov on 03/10/2025.
//

import SwiftUI

struct PrimaryActionButtonStyle: ButtonStyle {
    let bg: Color
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 14, weight: .bold, design: .monospaced))
            .foregroundColor(.black)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .background(bg.opacity(configuration.isPressed ? 0.85 : 1.0))
            .cornerRadius(10)
    }
}

struct SecondaryActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 14, weight: .semibold, design: .monospaced))
            .foregroundColor(.white)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(Color.gray.opacity(configuration.isPressed ? 0.6 : 0.4))
            .cornerRadius(10)
    }
}
