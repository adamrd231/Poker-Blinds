//
//  ViewModel.swift
//  PokerBlinds
//
//  Created by Adam Reed on 6/6/23.
//

import SwiftUI
import GoogleMobileAds
import Combine
import AVFoundation

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
    
    @Published var timerInfo = TimerModel(currentLevel: 1, currentTime: 10)
    
    var totalGameTime: (Int, Int) {
        getTotalGameTime(roundTime: timerInfo.currentTime, numberOfRounds: blindsArray.count)
    }
    @Published var blindInfo = BlindsModel(startingSmallBlind: 100, amountToRaiseBlinds: 100, blindLimit: 1000)
    @Published var blindsArray: [BlindLevel] = [BlindLevel(smallBlind: 100)]
    
    @Published var keepScreenOpen: Bool = false
    @Published var currentLevel: Int = 1
    
    @Published var backupTimer: TimerModel?
    
    @Published var isTimerRunning: TimerStates = TimerStates.hasNotBeenStarted
    
    // Store manager for in-app purchases
    @Published var storeManager = StoreManager()
    @Published var currentSound: Int = 0
    
    // Google Admob variables
    @State var interstitial: GADInterstitialAd?
    @State var playedInterstitial = false
    
    private var cancellable = Set<AnyCancellable>()
    
    // Timer object
    var timer = Timer()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        $blindInfo
            .sink { [weak self] (BlindsModel) in
                var newBlinds:[BlindLevel] = []
                var start = BlindsModel.startingSmallBlind
                while start <= BlindsModel.blindLimit {
                    newBlinds.append(BlindLevel(smallBlind: start))
                    start += BlindsModel.amountToRaiseBlinds
                }
                self?.blindsArray = newBlinds
            }
            .store(in: &cancellable)
    }
    
    func pokerTimerCountdown() {
        timerInfo.currentTime -= 1
        if timerInfo.currentTime == 0 {
            
        }
    }
    
    func runTimer() {
        self.isTimerRunning = .isRunning
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true ) { _ in
            if self.timerInfo.currentTime > 0 {
                self.pokerTimerCountdown()
                if self.timerInfo.currentTime == 0 {
                    // play noise
                    print("Playing sound")
                    SoundManager.instance.playSound(sound: SoundManager.instance.allSounds[self.currentSound])
                }
                
            // New Level
            } else if self.timerInfo.currentTime == 0 {
                if let backup = self.backupTimer {
                    self.timerInfo.currentTime = backup.currentTime
                    self.timerInfo.currentLevel += 1
                }
               
            // Reset
            } else {
                self.resetTimer()
            }
        }
    }
    
    func startTimer() {
        // make a copy for backing up stuff
        backupTimer = timerInfo
        runTimer()
        
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
