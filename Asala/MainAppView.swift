//
//  MainAppView.swift
//  Asala
//
//  Created by Omar Seyfetdinov on 05/09/2025.
//

import SwiftUI

enum SidebarTab: String, CaseIterable {
    case quest = "QUEST"
    case explore = "EXPLORE"
    case maps = "MAPS"
    case ranks = "RANKS"
    case settings = "SETTINGS"
}

struct MainAppView: View {
    @State private var showSidebar = false
    @State private var selected: SidebarTab = .explore

    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()

            // MAIN CONTENT
            Group {
                switch selected {
                case .quest:    QuestView()
                case .explore:  ExploreScreen()
                case .maps:     MapsScreen()
                case .ranks:    PlaceholderScreen(title: "RANKS")
                case .settings: PlaceholderScreen(title: "SETTINGS")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // SIDEBAR SLIDE-IN
            if showSidebar {
                SidebarView(selected: $selected)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(.move(edge: .leading))
                    .zIndex(1)
            }

            // MENU BUTTON
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                            showSidebar.toggle()
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(Color.yellow)
                                .frame(width: 56, height: 56)
                                .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 3)

                            Image(systemName: showSidebar ? "xmark" : "line.3.horizontal")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.black)
                        }
                    }
                    .padding(20)
                }
            }
            .zIndex(2)
        }
    }
}

struct PlaceholderScreen: View {
    let title: String
    var body: some View {
        VStack {
            Text(title)
                .font(Theme.pixel(28))
                .foregroundColor(Theme.accent)
                .padding(.top, 24)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.bg)
    }
}

