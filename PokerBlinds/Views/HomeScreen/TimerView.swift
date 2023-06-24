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
                LargeText(text: "Level \(timerInfo.currentLevel)", textSize: 40)
                LargeText(text: timerInfo.currentSeconds < 10 ? "\(timerInfo.currentMinutes):0\(timerInfo.currentSeconds)" : "\(timerInfo.currentMinutes):\(timerInfo.currentSeconds)", textSize: 100)
            }
            
            Circle()
                .stroke(Color.theme.mainButton.opacity(0.25), style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .frame(width: UIScreen.main.bounds.width * 0.9, height: 300)
            Circle()
                .trim(from: 0, to: CGFloat(timerInfo.currentTime) / CGFloat(backupTimer.currentTime))
                .stroke(Color.theme.mainButton, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .frame(width: UIScreen.main.bounds.width * 0.9, height: 300)
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
