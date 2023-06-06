//
//  ViewModel.swift
//  PokerBlinds
//
//  Created by Adam Reed on 6/6/23.
//

import SwiftUI
import GoogleMobileAds

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
    @Published var storeManager = StoreManager()
    
    // Google Admob variables
    @State var interstitial: GADInterstitialAd?
    @State var playedInterstitial = false
    
    // Timer object
    @State var timer = Timer()
    
    func pokerTimerCountdown() {
        if pokerGame.currentTime > 0 {
            pokerGame.currentTime -= 1
        }
//        if currentTimer > 0 {
//            currentTimer -= 1
//        } else {
//            currentTimer = currentTimerBackup
//            currentLevel += 1
//            if smallBlind >= blindLimit {
//
//                playSound()
//
//                return
//            } else {
//                smallBlind += raiseBlindsBy
//                playSound()
//            }
//
//
//        }
    }
    
    func startTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true ) { _ in
            self.pokerTimerCountdown()
        }
    }
    
    func stopTimer() {
        self.timer.invalidate()
    }
    

}
