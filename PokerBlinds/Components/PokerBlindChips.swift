//
//  PokerBlindChips.swift
//  PokerBlinds
//
//  Created by Adam Reed on 9/4/23.
//

import SwiftUI

struct PokerChip: View {
    
    let chipColor: Color
    
    var body: some View {
        ZStack {
            Image(systemName: "circle.fill")
                .foregroundColor(Color.theme.lightGray)
            Image(systemName: "circle.dashed.inset.filled")
                .foregroundColor(chipColor)
        }
    }
}

struct SmallBlindHeader: View {
    var body: some View {
        HStack {
            PokerChip(chipColor: Color.theme.mainButton)
            Text("small")
                .bold()
                .foregroundColor(Color.theme.text)
            
        }
    }
}

struct BigBlindHeader: View {
    var body: some View {
        HStack {
            ZStack {
                PokerChip(chipColor: Color.theme.text)
                    .offset(x: -3)
                
                PokerChip(chipColor: Color.theme.mainButton)
                .offset(x: 3)
            }
            .rotationEffect(Angle(degrees: 30))
            Text("big blind")
                .bold()
                .foregroundColor(Color.theme.text)
            
        }
        
    }
}
