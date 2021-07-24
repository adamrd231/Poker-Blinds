//
//  TimerView.swift
//  PokerBlinds
//
//  Created by Adam Reed on 7/18/21.
//

import SwiftUI

struct TimerView: View {
    
    @EnvironmentObject var pokerBlinds: PokerBlinds
    
    var body: some View {
        VStack {
            VStack {
                Text("Level \(pokerBlinds.currentLevel)").font(.title)
                if pokerBlinds.currentSeconds < 10 {
                    Text("\(pokerBlinds.currentMinutes):0\(pokerBlinds.currentSeconds)").font(.largeTitle).bold()
                } else {
                    Text("\(pokerBlinds.currentMinutes):\(pokerBlinds.currentSeconds)").font(.largeTitle).bold()
                }
                HStack {
                    Text("\(pokerBlinds.smallBlind)").font(.title3)
                    Text("|")
                    Text("\(pokerBlinds.bigBlind)").font(.title3)
                }
            }.padding()
            
            VStack {
                Text("Starting Stack \(pokerBlinds.chipStack)")
                Text("Average Stack \(pokerBlinds.averageChipStack)")
                Text("Players: \(pokerBlinds.playerCount)")
                
            }
           
            
            
            
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView().environmentObject(PokerBlinds())
    }
}
