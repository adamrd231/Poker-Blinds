//
//  PokerBlindModel.swift
//  PokerBlinds
//
//  Created by Adam Reed on 7/17/21.
//

import SwiftUI
import AVFoundation
import Foundation

struct Blinds {
    var levels: [BlindLevel]
}

struct BlindLevel: Hashable, Identifiable {
    var id = UUID()
    var smallBlind: Int
    var bigBlind: Int {
        return smallBlind * 2
    }
}

struct BlindsModel: Codable {
    var startingSmallBlind: Int
    var amountToRaiseBlinds: Int
    var blindLimit: Int
}

struct TimerModel: Codable {
    var currentLevel: Int
    var currentTime: Int
    var currentSeconds: Int {
        return currentTime % 60
    }
    var currentMinutes: Int {
        return currentTime / 60
    }
}

struct PokerGameModel: Identifiable {
    // Timer info
    var id = UUID()
   
    // Blinds info
    var blindsModel: BlindsModel

}

func getTotalGameTime(roundTime: Int, numberOfRounds: Int) -> (min: String, sec: String) {
    let totalTime = roundTime * numberOfRounds
    return ((totalTime / 60).description, (totalTime % 60).description)
}
