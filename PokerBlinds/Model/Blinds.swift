//
//  Blinds.swift
//  PokerBlinds
//
//  Created by Adam Reed on 7/6/23.
//

import SwiftUI

struct BlindsModel: Codable {
    var startingSmallBlind: Int
    var amountToRaiseBlinds: Int
    var blindLimit: Int
}

struct BlindLevel: Hashable, Identifiable, Codable {
    var id = UUID()
    var smallBlind: Int
    var bigBlind: Int {
        return smallBlind * 2
    }
}
