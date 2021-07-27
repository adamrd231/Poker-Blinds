//
//  Options.swift
//  PokerBlinds
//
//  Created by Adam Reed on 7/20/21.
//

import SwiftUI

class Options: ObservableObject, Identifiable {
    @Published var chipStack = 9000
    @Published var currentTimer = 120
    var currentSeconds: Int { get { currentTimer % 60 }}
    var currentMinutes: Int { get { currentTimer / 60 }}
    @Published var players = 9
    // Preset Blinds to choose from
    @Published var blindsArray:[Int] = [100, 200, 300, 400, 500, 600, 700, 800, 900, 1000]
    
    @Published var smallBlind = 100
    @Published var raiseBlindsBy = 100
    var bigBlind:Int { get { smallBlind * 2 }}
    
    @Published var smallBlindLimit = 1000
    var bigBlindLimit:Int { get { smallBlindLimit * 2 }}
}
