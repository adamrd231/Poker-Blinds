//
//  BlindLevelModel.swift
//  PokerBlinds
//
//  Created by Adam Reed on 7/6/23.
//

import SwiftUI

class BlindLevelModel {
    var currentLevel: Int = 0
    var startingOptions: BlindsModel = BlindsModel(startingSmallBlind: 100, amountToRaiseBlinds: 100, blindLimit: 1000)
    var blindLevels: [BlindLevel] = []
    
    func getCurrentBlind() -> BlindLevel {
        if currentLevel + 1 >= blindLevels.count {
            return blindLevels.last ?? BlindLevel(smallBlind: 1000)
        } else {
            return blindLevels[currentLevel]
        }
    }
    
    func getPreviousBlinds() -> BlindLevel? {
        if currentLevel == 0 {
            return nil
        } else if currentLevel + 1 > blindLevels.count {
            return blindLevels[blindLevels.count - 1]
        } else {
            return blindLevels[currentLevel - 1]
        }
    }
    
    func getNextBlinds() -> BlindLevel? {
        if currentLevel + 1 >= blindLevels.count {
            return nil
        } else {
            return blindLevels[currentLevel + 1]
        }
    }
}
