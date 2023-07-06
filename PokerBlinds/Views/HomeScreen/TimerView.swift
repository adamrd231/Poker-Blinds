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
    let circleSize: CGFloat = 275
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                LargeText(text: "Level \(timerInfo.currentLevel + 1)", textSize: 40)
                ClockLayout(currentSeconds: timerInfo.currentSeconds, currentMinutes: timerInfo.currentMinutes, largeText: true)
            }
            
            Circle()
                .stroke(Color.theme.text.opacity(0.15), style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .frame(width: circleSize, height: circleSize)
            Circle()
                .trim(from: 0, to: CGFloat(timerInfo.currentTime) / CGFloat(backupTimer.currentTime))
                .stroke(Color.theme.mainButton.opacity(0.9), style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .frame(width: circleSize, height: circleSize)
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
                currentTime: 10,
                elapsedTime: 0),
            backupTimer: TimerModel(
                currentLevel: 100,
                currentTime: 300,
                elapsedTime: 1
            )
        )
    }
}
