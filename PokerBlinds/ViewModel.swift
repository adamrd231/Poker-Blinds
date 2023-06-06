//
//  ViewModel.swift
//  PokerBlinds
//
//  Created by Adam Reed on 6/6/23.
//

import SwiftUI

class ViewModel: ObservableObject {
    @Published var pokerGame = PokerGameModel(
        currentTime: 10,
        isTimerRunning: .hasNotBeenStarted,
        blindsModel: BlindsModel(
            currentLevel: 1,
            smallBlind: 100,
            amountToRaiseBlinds: 100),
        keepScreenOpen: true)
    
    // Store manager for in-app purchases
    @Published var storeManager: StoreManager
    
    // Google Admob variables
    @State var interstitial: GADInterstitialAd?
    @State var playedInterstitial = false
    
    // Timer object
    @State var timer = Timer.publish(every: 1, on: .main, in: .common)
}
