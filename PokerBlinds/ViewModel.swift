//
//  ViewModel.swift
//  PokerBlinds
//
//  Created by Adam Reed on 6/6/23.
//

import SwiftUI
import GoogleMobileAds

enum TimerStates: String {
    case isRunning
    case isPaused
    case hasNotBeenStarted
}

extension TimerStates: CustomStringConvertible {
    var description: String {
        return "\(rawValue)"
    }
}

class ViewModel: ObservableObject {
    
    @Published var timerInfo = TimerModel(currentTime: 10)
    @Published var blinds = BlindsModel(currentLevel: 1, smallBlind: 100, amountToRaiseBlinds: 100)
    @Published var keepScreenOpen: Bool = false
    
    @Published var backupTimer: TimerModel?
    
    @Published var isTimerRunning: TimerStates = TimerStates.hasNotBeenStarted
    
    // Store manager for in-app purchases
    @Published var storeManager = StoreManager()
    
    // Google Admob variables
    @State var interstitial: GADInterstitialAd?
    @State var playedInterstitial = false
    
    // Timer object
    var timer = Timer()
    
    func pokerTimerCountdown() {
        timerInfo.currentTime -= 1
    }
    
    func startTimer() {
        self.isTimerRunning = .isRunning
        // make a copy for backing up stuff
        backupTimer = timerInfo
        print("Start")
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true ) { _ in
            if self.timerInfo.currentTime > 0 {
                self.pokerTimerCountdown()
            } else if self.timerInfo.currentTime == 0 {
                if let backup = self.backupTimer {
                    self.timerInfo.currentTime = backup.currentTime
                    self.timerInfo.currentLevel += 1
                    self.blinds.smallBlind += self.blinds.amountToRaiseBlinds
                }
            } else {
                self.resetTimer()
            }
        }
    }
    
    func pauseTimer() {
        self.isTimerRunning = .isPaused
        self.timer.invalidate()
    }
    
    func resetTimer() {
        
        self.timer.invalidate()
        self.isTimerRunning = .hasNotBeenStarted
        // Reset to backup values
        if let backup = self.backupTimer {
            self.timerInfo = backup
            self.backupTimer = nil
        }
        
        // How to handle if this fails?
    }
}
