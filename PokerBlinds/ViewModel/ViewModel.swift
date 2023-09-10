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

class ViewModel: ObservableObject {
    // Models for app
    var timer = Timer()
    @Published var timerInfo = TimerModel(currentLevel: 0, currentTime: 600, elapsedTime: 0)
    @Published var backupTimer: TimerModel?
    @Published var isTimerRunning: TimerStates = TimerStates.hasNotBeenStarted
    @Published var totalGameTime: Int = 0
    
    // Blind info and levels
    @Published var blindGameOptions = BlindsModel(startingSmallBlind: 100, amountToRaiseBlinds: 100, blindLimit: 1000)
    @Published var blindLevels: [BlindLevel] = []
    
    // Google Admob variables
    @State var interstitial: GADInterstitialAd?
    @State var playedInterstitial = false
    
    // In-App Purchases -- track whether users have access
    @Published var usingRoundTimer: Bool = false
    @Published var quickEndGame: Bool = false
    
    // Options for user
    @Published var keepScreenOpen: Bool = false

    // Sound selections
    private var introGameSound: SoundEffect = SoundEffect(title: "Guitar", path: "guitar", type: .wav)
    @Published var currentSound: SoundEffect = SoundEffect(title: "Bell", path: "bell", type: .wav)
    @Published var roundWarningSound: SoundEffect = SoundEffect(title: "Clock", path: "clockTicking", type: .wav)
    
    // Idle timer
    @Published var isIdleTimerActive: Bool = false
    
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        // Setup subscriber on blind model to populate blind table
        // Updates whenever a user changes blind options
        addSubscribers()
    }
    
    func addSubscribers() {
        // Subscribe to the blinds so to update blind tables
        $blindGameOptions
            .combineLatest($quickEndGame, $timerInfo)
            .map(updateBlindTables)
            .sink { [weak self] (returnedBlinds, returnedGameTime) in
                self?.blindLevels = returnedBlinds
                self?.totalGameTime = returnedGameTime
            }
            .store(in: &cancellable)
    }
    
    func updateBlindTables(blindGameOptions: BlindsModel, usingQuickEndgameRule: Bool, timer: TimerModel) -> ([BlindLevel], Int) {
        // Blinds
        var newBlinds:[BlindLevel] = []
        var start = blindGameOptions.startingSmallBlind
        while start <= blindGameOptions.blindLimit {
            newBlinds.append(BlindLevel(smallBlind: start))
            start += blindGameOptions.amountToRaiseBlinds
        }
        if usingQuickEndgameRule {
            // Add double time as final level - or double levels?
            newBlinds.append(newBlinds.last ?? BlindLevel(smallBlind: 1000))
            // Double last blind for final level
            newBlinds.append(BlindLevel(smallBlind: (newBlinds.last?.smallBlind ?? 1000) * 2))
        }
        let totalGameTime = newBlinds.count * timer.currentTime
        return (newBlinds, totalGameTime)
    }
    
    func runTimer(useWarningTimer: Bool) {
        self.isTimerRunning = .isRunning
        isIdleTimerActive = true
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true ) { _ in
            if self.timerInfo.currentTime > 0 {
                // Round Timer -- Update poker timer value
                self.timerInfo.currentTime -= 1
                self.timerInfo.elapsedTime += 1
                // Warning Timer -- un-lockable feature
                if self.usingRoundTimer && useWarningTimer && self.timerInfo.currentTime == 10 {
                    SoundManager.instance.playSound(sound: self.roundWarningSound)
                    
                }
                // New Level
                if self.timerInfo.currentTime == 0 {
                    SoundManager.instance.playSound(sound: self.currentSound)
                    self.startNewLevel()
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                }
            } else {
                self.resetTimer()
            }
        }
    }
    
    func fastForward() {
        guard timerInfo.currentTime - 10 > 0 else { return }
        timerInfo.currentTime -= 10
    }

    func rewind() {
        guard timerInfo.currentTime + 10 < backupTimer?.currentTime ?? 0 else { return }
        timerInfo.currentTime += 10
    }
    
    func startNewLevel() {
        if let backup = self.backupTimer {
            self.timerInfo.currentTime = backup.currentTime
            self.timerInfo.currentLevel += 1
        }
    }
    
    func startTimer(useWarningTimer: Bool) {
        // make a copy for backing up stuff
        SoundManager.instance.playSound(sound: introGameSound)
        runTimer(useWarningTimer: useWarningTimer)
        backupTimer = timerInfo
    }
    
    func pauseTimer() {
        self.isTimerRunning = .isPaused
        self.timer.invalidate()
        isIdleTimerActive = false
    }
    
    func resetTimer() {
        self.timer.invalidate()
        self.isTimerRunning = .hasNotBeenStarted
        isIdleTimerActive = false
        // Reset to backup values
        if let backup = self.backupTimer {
            self.timerInfo = backup
            self.backupTimer = nil
        }
    }
    
    // MARK: User --- money save state
//    func saveInfo() {
//        let encoder = JSONEncoder()
//        let defaults = UserDefaults.standard
//        if let encoded = try? encoder.encode(timerInfo) {
//            defaults.set(encoded, forKey: "timerInfo")
//        }
//        if let blind = try? encoder.encode(blindInfo) {
//            defaults.set(blind, forKey: "blindInfo")
//        }
//        if let screenSetting = try? encoder.encode(keepScreenOpen) {
//            defaults.set(screenSetting, forKey: "screenSetting")
//        }
//        if let level = try? encoder.encode(timerInfo.currentLevel) {
//            defaults.set(level, forKey: "level")
//        }
//        if let timerRunnin = try? encoder.encode(isTimerRunning) {
//            defaults.set(timerRunnin, forKey: "timer")
//        }
//        if let backup = try? encoder.encode(backupTimer) {
//            defaults.set(backup, forKey: "backup")
//        }
//    }
//    
//    func loadInfo() {
//        let defaults = UserDefaults.standard
//        let decoder = JSONDecoder()
//        if let timerInfo = defaults.object(forKey: "timerInfo") as? Data {
//            if let info = try? decoder.decode(TimerModel.self, from: timerInfo) {
//                self.timerInfo = info
//            }
//        }
//        if let blindInfo = defaults.object(forKey: "blindInfo") as? Data {
//            if let blinds = try? decoder.decode(BlindsModel.self, from: blindInfo) {
//                self.blindInfo = blinds
//            }
//        }
//        if let screenSetting = defaults.object(forKey: "screenSetting") as? Data {
//            if let option = try? decoder.decode(Bool.self, from: screenSetting) {
//                self.keepScreenOpen = option
//            }
//        }
//        if let level = defaults.object(forKey: "level") as? Data {
//            if let option = try? decoder.decode(Int.self, from: level) {
//                self.timerInfo.currentLevel = option
//            }
//        }
//        if let timer = defaults.object(forKey: "timer") as? Data {
//            if let isRunning = try? decoder.decode(TimerStates.self, from: timer) {
//                self.isTimerRunning = isRunning
//            }
//        }
//        if let backup = defaults.object(forKey: "backup") as? Data {
//            if let info = try? decoder.decode(TimerModel.self, from: backup) {
//                self.backupTimer = info
//            }
//        }
//    }
}
