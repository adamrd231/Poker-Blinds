//
//  ViewModel.swift
//  PokerBlinds
//
//  Created by Adam Reed on 6/6/23.
//

import SwiftUI
import GoogleMobileAds

class ViewModel: ObservableObject {
    
    @Published var timerInfo = TimerModel(currentTime: 10, isTimerRunning: TimerStates.hasNotBeenStarted)
    
    @Published var blinds = BlindsModel(currentLevel: 1, smallBlind: 100, amountToRaiseBlinds: 100)
    
    @Published var keepScreenOpen: Bool = false
    
    // Store manager for in-app purchases
    @Published var storeManager = StoreManager()
    
    // Google Admob variables
    @State var interstitial: GADInterstitialAd?
    @State var playedInterstitial = false
    
    // Timer object
    @State var timer = Timer()
    
    func pokerTimerCountdown() {
        if timerInfo.currentTime > 0 {
            timerInfo.currentTime -= 1
        }
    }
    
    func startTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true ) { _ in
            self.pokerTimerCountdown()
            self.timerInfo.isTimerRunning = .isRunning
        }
    }
    
    func stopTimer() {
        self.timer.invalidate()
    }
    

}
