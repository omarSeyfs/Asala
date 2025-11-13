//
//  Models.swift
//  Asala
//
//  Created by Omar Seyfetdinov on 03/10/2025.
//
// File: Models.swift
import SwiftUI

// Simple models shared across screens
struct ShopItem: Identifiable, Equatable, Codable {
    let id: UUID = UUID()
    var name: String
    var imageName: String
    var price: Int
    var owned: Bool = false
    var equipped: Bool = false
}

struct QuestModel: Identifiable, Codable {
    let id = UUID()
    var title: String
    var subtitle: String
    var progress: Int
    var goal: Int
    var rewardCoins: Int
    var rewardXP: Int
    var claimed: Bool = false
    var completed: Bool { progress >= goal }
}
