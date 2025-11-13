//
//  ShopScreen.swift
//  Asala
//
//  Created by Omar Seyfetdinov on 03/10/2025.
//

import SwiftUI

struct ShopScreen: View {
    @Binding var coins: Int
    @Binding var items: [ShopItem]
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack(spacing: 12) {
                HStack {
                    Text("SHOP")
                        .font(.system(size: 22, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                    Spacer()
                    Text("Coins: \(coins)")
                        .foregroundColor(.white)
                }
                .padding(.horizontal)

                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 140))], spacing: 12) {
                        ForEach(items.indices, id: \.self) { idx in
                            let item = items[idx]
                            VStack(spacing: 8) {
                                Image(item.imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 80)

                                Text(item.name)
                                    .foregroundColor(.white)
                                if item.equipped {
                                    Text("Equipped")
                                        .font(.caption2)
                                        .foregroundColor(.green)
                                } else if item.owned {
                                    Button("Equip") { equip(at: idx) }
                                        .buttonStyle(PrimaryActionButtonStyle(bg: Color(.sRGB, red: 78/255, green: 210/255, blue: 115/255)))
                                } else {
                                    Button("Buy \(item.price) 🪙") { buy(at: idx) }
                                        .buttonStyle(PrimaryActionButtonStyle(bg: Color(.sRGB, red: 249/255, green: 203/255, blue: 50/255)))
                                }
                            }
                            .padding()
                            .background(Color.black.opacity(0.25))
                            .cornerRadius(12)
                        }
                    }
                    .padding()
                }
            }
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Close") { dismiss() } } }
            .background(Color.clear)
        }
    }

    private func buy(at idx: Int) {
        guard items.indices.contains(idx) else { return }
        if coins >= items[idx].price {
            coins -= items[idx].price
            items[idx].owned = true
            for i in items.indices { items[i].equipped = false }
            items[idx].equipped = true
        }
    }

    private func equip(at idx: Int) {
        for i in items.indices { items[i].equipped = false }
        items[idx].equipped = true
    }
}
