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

enum TimerStates: String, Codable {
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
                    if let backup = self.backupTimer {
                        self.timerInfo.currentTime = backup.currentTime
                        self.timerInfo.currentLevel += 1
                    }
                }
                
            // New Level
            } else {
                self.resetTimer()
            }
        }
    }
    
    func startTimer() {
        // make a copy for backing up stuff
        runTimer()
        backupTimer = timerInfo
        
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
    }
    
    // MARK: User --- money save state
    func saveInfo() {
        let encoder = JSONEncoder()
        let defaults = UserDefaults.standard
        if let encoded = try? encoder.encode(timerInfo) {
            defaults.set(encoded, forKey: "timerInfo")
        }
        if let blind = try? encoder.encode(blindInfo) {
            defaults.set(blind, forKey: "blindInfo")
        }
        if let screenSetting = try? encoder.encode(keepScreenOpen) {
            defaults.set(screenSetting, forKey: "screenSetting")
        }
        if let level = try? encoder.encode(currentLevel) {
            defaults.set(level, forKey: "level")
        }
        if let timerRunnin = try? encoder.encode(isTimerRunning) {
            defaults.set(timerRunnin, forKey: "timer")
        }
        if let backup = try? encoder.encode(backupTimer) {
            defaults.set(backup, forKey: "backup")
        }
    }
    
    func loadInfo() {
        let defaults = UserDefaults.standard
        let decoder = JSONDecoder()
        if let timerInfo = defaults.object(forKey: "timerInfo") as? Data {
            if let info = try? decoder.decode(TimerModel.self, from: timerInfo) {
                self.timerInfo = info
            }
        }
        if let blindInfo = defaults.object(forKey: "blindInfo") as? Data {
            if let blinds = try? decoder.decode(BlindsModel.self, from: blindInfo) {
                self.blindInfo = blinds
            }
        }
        if let screenSetting = defaults.object(forKey: "screenSetting") as? Data {
            if let option = try? decoder.decode(Bool.self, from: screenSetting) {
                self.keepScreenOpen = option
            }
        }
        if let level = defaults.object(forKey: "level") as? Data {
            if let option = try? decoder.decode(Int.self, from: level) {
                self.currentLevel = option
            }
        }
        if let timer = defaults.object(forKey: "timer") as? Data {
            if let isRunning = try? decoder.decode(TimerStates.self, from: timer) {
                self.isTimerRunning = isRunning
            }
        }
        if let backup = defaults.object(forKey: "backup") as? Data {
            if let info = try? decoder.decode(TimerModel.self, from: backup) {
                self.backupTimer = info
            }
        }
    }
}
