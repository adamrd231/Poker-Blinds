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
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                LargeText(text: "Level \(timerInfo.currentLevel)", huge: false)
                LargeText(text: timerInfo.currentSeconds < 10 ? "\(timerInfo.currentMinutes):0\(timerInfo.currentSeconds)" : "\(timerInfo.currentMinutes):\(timerInfo.currentSeconds)", huge: true)
            }
            
            Circle()
                .trim(from: 1, to: 0)
                .stroke(Color.black.opacity(0.09), style: StrokeStyle(lineWidth: 6, lineCap: .round))
                .frame(width: 275, height: 275)
            Circle()
                .trim(from: 0, to: CGFloat(timerInfo.currentTime) / CGFloat(timerInfo.currentTime))
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
        TimerView(
            blinds: BlindsModel(
                currentLevel: 1,
                smallBlind: 100,
                amountToRaiseBlinds: 100),
            timerInfo: TimerModel(
                currentTime: 10
            )
        )
    }
}
