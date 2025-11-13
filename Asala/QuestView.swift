//
//  QuestView.swift
//  Asala
//
//  Created by Omar Seyfetdinov on 03/10/2025.
//


import SwiftUI

struct QuestView: View {
    @State private var coins: Int = 64
    @State private var xp: Int = 11
    @State private var maxXp: Int = 30
    @State private var level: Int = 3

    @State private var showingShop: Bool = false
    @State private var showingQuests: Bool = false

    @State private var items: [ShopItem] = [
        ShopItem(name: "Beanie", imageName: "beanie", price: 5),
        ShopItem(name: "Sprout", imageName: "sprout", price: 5),
        ShopItem(name: "Sun Hat", imageName: "sunhat", price: 20),
        ShopItem(name: "Bday Hat", imageName: "bdayHat", price: 10),
        ShopItem(name: "Top Hat", imageName: "topHat", price: 10),
        ShopItem(name: "Sunglasses", imageName: "sunglasses", price: 5)
    ]

    @State private var quests: [QuestModel] = [
        QuestModel(title: "Avid Explorer", subtitle: "Visit 3 locations", progress: 2, goal: 3, rewardCoins: 20, rewardXP: 10),
        QuestModel(title: "Just Hatched", subtitle: "Visit your first location", progress: 1, goal: 1, rewardCoins: 5, rewardXP: 5),
        QuestModel(title: "Saadjat Savant", subtitle: "Visit 5 places", progress: 1, goal: 5, rewardCoins: 50, rewardXP: 15),
        QuestModel(title: "Qasr Quest", subtitle: "Visit 2 palaces", progress: 0, goal: 2, rewardCoins: 30, rewardXP: 10)
    ]

    var body: some View {
        ZStack {
            Color("BackgroundColor").ignoresSafeArea()

            VStack(spacing: 12) {
                HStack {
                    coinBox
                    Spacer()
                    xpPill
                }
                .padding(.horizontal)
                .padding(.top, 12)

                Spacer()

                ZStack {
                    Image("perryRock").resizable().scaledToFit().frame(height: 120)
                    Image("perryBase").resizable().scaledToFit().frame(width: 220)
                    if let eq = items.first(where: { $0.equipped }) {
                        Image(eq.imageName)
                            .resizable().scaledToFit()
                            .frame(width: 220 * hatScale(for: eq.imageName))
                            .offset(y: hatYOffset(for: eq.imageName, perryWidth: 220))
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .frame(height: 300)

                Text("Perry  •  Lvl \(level)")
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(Color.black.opacity(0.35))
                    .cornerRadius(10)

                Spacer()

                HStack(spacing: 12) {
                    Button(action: { showingShop = true }) {
                        HStack { Image(systemName: "bag.fill"); Text("SHOP") }
                    }
                    .buttonStyle(PrimaryActionButtonStyle(bg: Color(.sRGB, red: 249/255, green: 203/255, blue: 50/255)))

                    Button(action: { showingQuests = true }) {
                        HStack { Image(systemName: "list.bullet"); Text("QUESTS") }
                    }
                    .buttonStyle(PrimaryActionButtonStyle(bg: Color(.sRGB, red: 78/255, green: 210/255, blue: 115/255)))

                    Spacer()
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
        .sheet(isPresented: $showingShop) {
            ShopScreen(coins: $coins, items: $items)
                .presentationDetents([.fraction(0.85)])
        }
        .sheet(isPresented: $showingQuests) {
            QuestsScreen(quests: quests, coins: coins, xp: xp, maxXp: maxXp) { updatedCoins, updatedXp, updatedQuests in
                self.coins = updatedCoins
                self.xp = updatedXp
                self.quests = updatedQuests
                while self.xp >= self.maxXp {
                    self.xp -= self.maxXp
                    self.level += 1
                }
            }
            .presentationDetents([.fraction(0.9)])
        }
        .preferredColorScheme(.dark)
    }

    private var coinBox: some View {
        HStack(spacing: 8) {
            Text("🪙")
            Text("\(coins)").fontWeight(.bold)
        }
        .padding(8)
        .background(Color(.sRGB, red: 249/255, green: 203/255, blue: 50/255))
        .cornerRadius(10)
    }

    private var xpPill: some View {
        VStack(alignment: .trailing, spacing: 6) {
            HStack { Text("XP"); Text("\(xp)/\(maxXp)") }.foregroundColor(.white)
            GeometryReader { g in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10).fill(Color.black.opacity(0.25)).frame(height: 14)
                    RoundedRectangle(cornerRadius: 10).fill(Color(.sRGB, red: 78/255, green: 210/255, blue: 115/255))
                        .frame(width: max(8, (g.size.width) * CGFloat(min(1, Double(xp) / Double(maxXp)))), height: 14)
                }
            }.frame(height: 14)
        }
        .frame(width: 160)
        .padding(8)
        .background(Color.black.opacity(0.35))
        .cornerRadius(12)
    }
}


import SwiftUI

struct QuestView_Previews: PreviewProvider {
    static var previews: some View {
        QuestView()
    }
}
