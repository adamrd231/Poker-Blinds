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

        VStack(alignment: .center) {

            ZStack {
                
                
                
                VStack {
                    Text("Level \(pokerBlinds.currentLevel)").font(.largeTitle)
                    if pokerBlinds.currentSeconds < 10 {
                        Text("\(pokerBlinds.currentMinutes):0\(pokerBlinds.currentSeconds)").font(.system(size: 75.0)).bold()
                    } else {
                        Text("\(pokerBlinds.currentMinutes):\(pokerBlinds.currentSeconds)").font(.system(size: 75.0)).bold()
                    }
                    HStack {
                        Text("\(pokerBlinds.smallBlind)").font(.title)
                        Text("|").font(.title3)
                        Text("\(pokerBlinds.bigBlind)").font(.title)
                    }
                    HStack {
                        Text("\(pokerBlinds.smallBlind + pokerBlinds.raiseBlindsBy)").font(.subheadline)
                        Text("|").font(.subheadline)
                        Text("\((pokerBlinds.smallBlind + pokerBlinds.raiseBlindsBy) * 2)").font(.subheadline)
                    }
                }.padding()
                
                Circle()
                    .trim(from: 0, to: 1)
                    .stroke(Color.black.opacity(0.09), style: StrokeStyle(lineWidth: 30, lineCap: .round))
                    .frame(width: 300, height: 300)
                Circle()
                    .trim(from: 0, to: CGFloat(pokerBlinds.currentTimer) / CGFloat(pokerBlinds.currentTimerBackup))
                    .stroke(Color.black.opacity(0.3), style: StrokeStyle(lineWidth: 30, lineCap: .round))
                    .frame(width: 300, height: 300)
            }
            
            
            VStack {
                Text("Starting Stack \(pokerBlinds.chipStack)")
                Text("Average Stack \(pokerBlinds.averageChipStack)")
                Text("Players: \(pokerBlinds.playerCount)")
                
            }.padding()
            .background(Color(.systemGray6))
            .foregroundColor(.primary)
            .cornerRadius(25.0)
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView().environmentObject(PokerBlinds()).environmentObject(Options())
    }
}
