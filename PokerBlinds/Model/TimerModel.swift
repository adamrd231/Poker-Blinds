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
    var elapsedTIme: Int
    var currentSeconds: Int {
        return currentTime % 60
    }
    var currentMinutes: Int {
        return currentTime / 60
    }
    
    var elapsedTImeCurrentSeconds: Int {
        return elapsedTIme % 60
    }
    var elapsedTImeCurrentMinutes: Int {
        return elapsedTIme / 60
    }
}
