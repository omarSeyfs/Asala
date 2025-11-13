//
//  QuestsScreen.swift
//  Asala
//
//  Created by Omar Seyfetdinov on 03/10/2025.
//


import SwiftUI

struct QuestsScreen: View {
    @Environment(\.dismiss) private var dismiss

    @State var quests: [QuestModel]
    @State var coins: Int
    @State var xp: Int
    let maxXp: Int
    var onUpdate: ((Int, Int, [QuestModel]) -> Void)? = nil

    var body: some View {
        NavigationView {
            VStack(spacing: 12) {
                Text("QUESTS")
                    .font(.system(size: 22, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(quests.indices, id: \.self) { idx in
                            QuestRow(quest: quests[idx]) {
                                if !quests[idx].claimed && quests[idx].completed {
                                    quests[idx].claimed = true
                                    coins += quests[idx].rewardCoins
                                    xp += quests[idx].rewardXP
                                }
                            }
                        }
                    }
                    .padding()
                }
                HStack {
                    Button("Close") {
                        onUpdate?(coins, xp, quests)
                        dismiss()
                    }
                    .buttonStyle(SecondaryActionButtonStyle())
                    Spacer()
                }
                .padding()
            }
        }
    }
}

struct QuestRow: View {
    let quest: QuestModel
    var onClaim: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    Text(quest.title).foregroundColor(.white)
                    Text(quest.subtitle).font(.caption).foregroundColor(.white.opacity(0.8))
                }
                Spacer()
                Text("\(quest.progress)/\(quest.goal)").foregroundColor(.white)
            }
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 8).fill(Color.black.opacity(0.25)).frame(height: 12)
                RoundedRectangle(cornerRadius: 8).fill(quest.completed ? Color(.sRGB, red: 78/255, green: 210/255, blue: 115/255) : Color.gray)
                    .frame(width: CGFloat(180.0 * min(1.0, Double(quest.progress) / Double(max(1, quest.goal)))) + 8, height: 12)
            }
            HStack { Spacer()
                if quest.completed {
                    Button(action: onClaim) {
                        Text(quest.claimed ? "Claimed" : "Claim")
                            .padding(.vertical, 8).padding(.horizontal, 16)
                            .background(quest.claimed ? Color.gray : Color(.sRGB, red: 78/255, green: 210/255, blue: 115/255))
                            .foregroundColor(.white).cornerRadius(10)
                    }
                    .disabled(quest.claimed)
                } else {
                    Text("Rewards: \(quest.rewardCoins) 🪙 • \(quest.rewardXP) XP").foregroundColor(.white.opacity(0.9))
                }
            }
        }
        .padding().background(Color.black.opacity(0.25)).cornerRadius(12)
    }
}

