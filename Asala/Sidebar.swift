//
//  Sidebar.swift
//  Asala
//
//  Created by Omar Seyfetdinov on 05/09/2025.
//

import SwiftUI

struct SidebarView: View {
    @Binding var selected: SidebarTab
    @State private var blink = false
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Theme.sidebar.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 36) {
                
                ForEach(SidebarTab.allCases, id: \.self) { tab in
                    HStack(spacing: 14) {
                        // Blinking arrow for the selected tab
                        Group {
                            if selected == tab {
                                Text(">")
                                    .font(Theme.pixel(28))
                                    .foregroundColor(Theme.accent)
                                    .opacity(blink ? 0.25 : 1.0)
                                    .onAppear {
                                        withAnimation(.easeInOut(duration: 0.6).repeatForever()) {
                                            blink.toggle()
                                        }
                                    }
                            } else {
                                Text(" ")
                                    .font(Theme.pixel(28))
                                    .frame(width: 18)
                            }
                        }
                        
                        Text(tab.rawValue)
                            .font(Theme.pixel(32))
                            .foregroundColor(Theme.text)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                                    selected = tab
                                }
                            }
                    }
                }
                
            }
        }
    }
}
