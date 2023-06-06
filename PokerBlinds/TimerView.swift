//
//  TimerView.swift
//  PokerBlinds
//
//  Created by Adam Reed on 7/18/21.
//

import SwiftUI

struct TimerView: View {
    
    let pokerGameModel: PokerGameModel
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Text("Level \(pokerGameModel.blindsModel.currentLevel)")
                    .font(.title)
                    .textCase(.uppercase)
                    .foregroundColor(Color(.darkGray))
                    .fontWeight(.heavy)
                if pokerGameModel.currentSeconds < 10 {
                    Text("\(pokerGameModel.currentMinutes):0\(pokerGameModel.currentSeconds)").font(.system(size: 75.0))
                        .fontWeight(.heavy)
                        .foregroundColor(Color(.darkGray))
                    
                } else {
                    Text("\(pokerGameModel.currentMinutes):\(pokerGameModel.currentSeconds)").font(.system(size: 75.0))
                        .fontWeight(.heavy)
                        .foregroundColor(Color(.darkGray))
                }
            }
            
            Circle()
                .trim(from: 1, to: 0)
                .stroke(Color.black.opacity(0.09), style: StrokeStyle(lineWidth: 6, lineCap: .round))
                .frame(width: 275, height: 275)
            Circle()
//                .trim(from: 0, to: CGFloat(pokerBlinds.currentTimer) / CGFloat(pokerBlinds.currentTimerBackup))
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
        TimerView(pokerGameModel: PokerGameModel(currentTime: 10, isTimerRunning: TimerStates.isPaused, blindsModel: BlindsModel(currentLevel: 1, smallBlind: 100, amountToRaiseBlinds: 100), keepScreenOpen: true))
    }
}
