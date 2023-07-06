//
//  TimerModel.swift
//  PokerBlinds
//
//  Created by Adam Reed on 7/6/23.
//

import SwiftUI

struct TimerModel: Codable {
    var currentLevel: Int
    var currentTime: Int
    var elapsedTime: Int
    
    var currentHours: Int {
        return currentTime / 3600
    }
    var currentMinutes: Int {
        return currentTime / 60
    }
    var currentSeconds: Int {
        return currentTime % 60
    }

    var elapsedTimeCurrentHours: Int {
        return elapsedTime / 3600
    }
    
    var elapsedTImeCurrentSeconds: Int {
        return elapsedTime % 60
    }
    var elapsedTImeCurrentMinutes: Int {
        return elapsedTime / 60
    }
}
