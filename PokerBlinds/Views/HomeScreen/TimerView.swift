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
    let clockFontSize: Double
    let durationClockFontSize: Double
    let cgSize: CGSize = CGSizeMake(50, 50)
    var body: some View {
        ZStack {
            ZStack {
                RoundedRectangle(cornerSize: cgSize)
                    .foregroundColor(Color.gray.opacity(0.1))
                    .frame(height: UIScreen.main.bounds.height * 0.3)
                RoundedRectangle(cornerSize: cgSize)
                    .foregroundColor(Color.blue.opacity(0.15))
                    .frame(height: UIScreen.main.bounds.height * 0.3 * ( CGFloat(timerInfo.currentTime) / CGFloat(backupTimer.currentTime)))
            }
            .frame(maxHeight: UIScreen.main.bounds.height * 0.3)
            
            VStack(spacing: 0) {
                Text("Level \(timerInfo.currentLevel + 1)")
                    .fontWeight(.bold)
                ClockLayout(time: timerInfo.currentTime, fontSize: clockFontSize)
                VStack(spacing: .zero) {
                    Text("Elapsed time")
                        .fontWeight(.bold)
                     
                    ClockLayout(time: timerInfo.elapsedTime, fontSize: durationClockFontSize)
                        .fontWeight(.regular)
                        .minimumScaleFactor(0.01)
                }
            }
        }
        .fixedSize()
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
                currentLevel: 0,
                currentTime: 10,
                elapsedTime: 0),
            backupTimer: TimerModel(
                currentLevel: 100,
                currentTime: 300,
                elapsedTime: 1
            ),
            clockFontSize: 10,
            durationClockFontSize: 10
        )
    }
}
