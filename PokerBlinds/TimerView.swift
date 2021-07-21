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
                Text("Round \(pokerBlinds.currentLevel)")
                if pokerBlinds.currentSeconds < 10 {
                    Text("\(pokerBlinds.currentMinutes):0\(pokerBlinds.currentSeconds)")
                } else {
                    Text("\(pokerBlinds.currentMinutes):\(pokerBlinds.currentSeconds)")
                }
                HStack {
                    Text("\(pokerBlinds.smallBlind)")
                    Text("|")
                    Text("\(pokerBlinds.bigBlind)")
                }
            }.padding()
            
            VStack {
                Text("Starting Chip Stack \(pokerBlinds.chipStack)")
                Text("Average Chip Stack \(pokerBlinds.averageChipStack)")
                Text("Players: \(pokerBlinds.playerCount)")
                
            }.padding()
           
            
            
            
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView().environmentObject(PokerBlinds())
    }
}
