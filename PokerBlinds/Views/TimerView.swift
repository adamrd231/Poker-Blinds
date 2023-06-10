//
//  TimerView.swift
//  PokerBlinds
//
//  Created by Adam Reed on 7/18/21.
//

import SwiftUI

struct TimerView: View {
    
    let blinds: BlindsModel
    let timerInfo: TimerModel
    let backupTimer: TimerModel
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                LargeText(text: "Level \(timerInfo.currentLevel)", huge: false)
                LargeText(text: timerInfo.currentSeconds < 10 ? "\(timerInfo.currentMinutes):0\(timerInfo.currentSeconds)" : "\(timerInfo.currentMinutes):\(timerInfo.currentSeconds)", huge: true)
            }
            
            Circle()

                .stroke(Color.theme.mainButton.opacity(0.35), style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .frame(width: 275, height: 275)
            Circle()
                .trim(from: 0, to: CGFloat(timerInfo.currentTime) / CGFloat(backupTimer.currentTime))
                .stroke(Color.theme.mainButton, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .frame(width: 275, height: 275)
                .rotationEffect(.init(degrees: 270))
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(
            blinds: BlindsModel(
                startingSmallBlind: 100,
                amountToRaiseBlinds: 100,
                blindLimit: 2000),
            timerInfo: TimerModel(
                currentLevel: 1,
                currentTime: 10
            ), backupTimer: TimerModel(currentLevel: 100, currentTime: 300)
        )
    }
}
