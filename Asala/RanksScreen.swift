//
//  RanksScreen.swift
//  Asala
//
//  Created by Sabrina C. Sales on 13/11/2025.
//

import SwiftUI

struct RanksScreen: View {
    var body: some View {
        
        ZStack {
            
            
            
             VStack {
             Image("leaderboardIcon.png")
             .resizable()
             .scaledToFit()
             .frame(width: 150, height: 150)
             
             ZStack { //text block
             
             VStack (alignment: .leading){
             Text("Leaderboard")
             .font(.system(size: 45, weight: .bold))
             .foregroundStyle(.white)
             Text("""
             Explore new places and complete quests
             to gain XP!
             """)
             
             
             .foregroundStyle(.white)
             
             }
             .padding()
             .background {
             Rectangle()
             // .frame(width: 350, height: 100)
             .foregroundStyle(Color.black.opacity(0.3))
             .clipShape(RoundedRectangle(cornerRadius: 15))
             }
             
             }
             
             
             //                //rows
                             rankRow(number: "#1", name: "Bob", xp: "76", iconLabel: "perryBase.png")
                             rankRow(number: "#2", name: "Amelia", xp: "64", iconLabel: "perryWithHat.png")
                             rankRow(number: "#3", name: "Alex", xp: "54", iconLabel: "perryWithSunhat.png")
                             rankRow(number: "#4", name: "Jude", xp: "43", iconLabel: "perryWithHat.png")
                             rankRow(number: "#5", name: "Sophia", xp: "27", iconLabel: "perryWithSprout.png")
                             rankRow(number: "#34", name: "You", xp: "21", iconLabel: "perryBase.png")
             }
             
             
            
        }
        
        .background {
            Image("gameBg.PNG")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 400, height: 900)
                .ignoresSafeArea()
        }
        
    }
        
}


struct rankRow: View {
    
    let number: String
    let name: String
    let xp: String
    let iconLabel: String
    
    var body: some View {
        
        HStack {
            Text(number)
                .fontWeight(.black)
                .foregroundStyle(Theme.accent)
            Text(name)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                Spacer()
            Text(xp + "XP")
                .fontWeight(.bold)
                .foregroundStyle(Theme.xpGreen)
            
            ZStack {
                Color(Theme.bg)
                Image(iconLabel)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .scaleEffect(2.4)
                    .offset(x: -3, y: 40, )
            }
                .clipShape(Circle()).frame(width:50, height: 50)
               
        }
        .padding(5)
        .frame(width: 350)
        .font(.system(size: 26))
       
        .background {
            
            RoundedRectangle(cornerRadius: 15)
                .frame(width: 350)
            
        }
    }
}


#Preview {
    RanksScreen()
}
