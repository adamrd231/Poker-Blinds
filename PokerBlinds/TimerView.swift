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
        ZStack {
            VStack(spacing: 0) {
                Text("Level \(pokerBlinds.currentLevel)")
                    .font(.title)
                    .textCase(.uppercase)
                    .foregroundColor(Color(.darkGray))
                    .fontWeight(.heavy)
                if pokerBlinds.currentSeconds < 10 {
                    Text("\(pokerBlinds.currentMinutes):0\(pokerBlinds.currentSeconds)").font(.system(size: 75.0))
                        .fontWeight(.heavy)
                        .foregroundColor(Color(.darkGray))
                    
                } else {
                    Text("\(pokerBlinds.currentMinutes):\(pokerBlinds.currentSeconds)").font(.system(size: 75.0))
                        .fontWeight(.heavy)
                        .foregroundColor(Color(.darkGray))
                }
            }
            
            Circle()
                .trim(from: 1, to: 0)
                .stroke(Color.black.opacity(0.09), style: StrokeStyle(lineWidth: 6, lineCap: .round))
                .frame(width: 275, height: 275)
            Circle()
                .trim(from: 0, to: CGFloat(pokerBlinds.currentTimer) / CGFloat(pokerBlinds.currentTimerBackup))
                .stroke(Color.black.opacity(0.3), style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .frame(width: 275, height: 275)
                .rotationEffect(.init(degrees: 270))
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView().environmentObject(PokerBlinds()).environmentObject(Options())
    }
}
