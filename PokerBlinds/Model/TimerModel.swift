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
    var currentSeconds: Int {
        return currentTime % 60
    }
    var currentMinutes: Int {
        return currentTime / 60
    }
    
    var elapsedTImeCurrentSeconds: Int {
        return elapsedTime % 60
    }
    var elapsedTImeCurrentMinutes: Int {
        return elapsedTime / 60
    }
}
