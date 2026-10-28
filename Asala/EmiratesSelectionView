//
//  EmiratesSelectionView.swift
//  Asala
//
//  Created by Omar Seyfetdinov on 29/02/2026.
//
import SwiftUI

struct EmirateSelectionView: View {
    @EnvironmentObject var appState: AppState

    @State private var selected: Set<String> = []
    let onComplete: () -> Void

    private let emirates = [
        "Abu Dhabi",
        "Dubai",
        "Sharjah",
        "Ajman",
        "Umm Al Quwain",
        "Ras Al Khaimah",
        "Fujairah",
        "Al Ain"
    ]

    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()

            VStack(spacing: 24) {
                Text("CHOOSE EMIRATES")
                    .font(Theme.pixel(28))
                    .foregroundColor(Theme.text)

                Text("Select the emirates you want to explore")
                    .font(Theme.pixel(12))
                    .foregroundColor(.white.opacity(0.7))

                LazyVGrid(
                    columns: [GridItem(.adaptive(minimum: 140))],
                    spacing: 16
                ) {
                    ForEach(emirates, id: \.self) { emirate in
                        emirateCard(emirate)
                    }
                }

                Button {
                    saveSelection()
                } label: {
                    Text("CONFIRM")
                }
                .buttonStyle(
                    PrimaryActionButtonStyle(bg: Theme.accent)
                )
                .disabled(selected.isEmpty)
                .opacity(selected.isEmpty ? 0.5 : 1)
            }
            .padding()
        }
    }

    private func emirateCard(_ name: String) -> some View {
        let isSelected = selected.contains(name)

        return Text(name.uppercased())
            .font(Theme.pixel(12))
            .foregroundColor(isSelected ? .black : .white)
            .frame(maxWidth: .infinity, minHeight: 60)
            .background(isSelected ? Theme.accent : Theme.panel)
            .cornerRadius(14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Theme.border, lineWidth: 1)
            )
            .onTapGesture {
                withAnimation(.spring()) {
                    if isSelected {
                        selected.remove(name)
                    } else {
                        selected.insert(name)
                    }
                }
            }
    }

    private func saveSelection() {
        let array = Array(selected)

        // Store locally
        UserDefaults.standard.set(array, forKey: "selected_emirates")

        // Update in-memory user model
        appState.userManager.user_details?.emirates = array

        onComplete()
    }
}
