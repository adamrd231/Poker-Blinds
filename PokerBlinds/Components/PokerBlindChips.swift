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
            Circle()
                .frame(width: 20, height: 20)
                .foregroundColor(Color.theme.lightGray)
            Circle()
                .strokeBorder(lineWidth: 4)
                .foregroundColor(chipColor)
                .frame(width: 20, height: 20)
            
            Image(systemName: "circle.dashed")
                .resizable()
                .foregroundColor(Color.theme.lightGray)
                .frame(width: 17, height: 17)
        }
    }
}

struct PokerChip_Previews: PreviewProvider {
    static var previews: some View {
        PokerChip(chipColor: Color.theme.mainButton)
            .previewLayout(.sizeThatFits)
    }
}


struct SmallBlindHeader: View {
    var body: some View {
        HStack {
            PokerChip(chipColor: Color.theme.text)
            Text("small blind")
                .bold()
                .foregroundColor(Color.theme.text)
            
        }
    }
}

struct BigBlindHeader: View {
    var body: some View {
        HStack {
            ZStack {
                PokerChip(chipColor: Color.theme.mainButton)
                    .offset(x: -6)
                PokerChip(chipColor: Color.theme.text)
                
               
            }
            .rotationEffect(Angle(degrees: 15))
            Text("big blind")
                .bold()
                .foregroundColor(Color.theme.text)
            
        }
        
    }
}
