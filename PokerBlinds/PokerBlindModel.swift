//
//  PokerBlindModel.swift
//  PokerBlinds
//
//  Created by Adam Reed on 7/17/21.
//

import SwiftUI
import AVFoundation
import Foundation

class PokerBlinds: ObservableObject, Identifiable {
    
    var audioPlayer: AVAudioPlayer?
    
    // MARK: Variables for running calc
    // Timer variables
    @Published var currentTimer = 300

    var currentSeconds: Int { get { currentTimer % 60 }}
    var currentMinutes: Int { get { currentTimer / 60 }}
    @Published var timerIsRunning = false
    @Published var timerIsPaused = false
    @Published var currentLevel = 1
    
    @Published var newChipCount = "9000"
    
    @Published var keepScreenOpen = true
    
    // Chip Stack Count
    @Published var chipStack = 9000
    @Published var playerStartingCount = 9
    @Published var playerCount = 9
    @Published var smallBlind = 100
    @Published var raiseBlindsBy = 100
    var averageChipStack:Int { get {(chipStack * playerStartingCount) / playerCount}}
    var bigBlind: Int { get { smallBlind * 2 }}
    var blindLimit = 1000
    @Published var firstTime = UserDefaults.standard.bool(forKey: "firstTime") ?? false {
    didSet {
        UserDefaults.standard.setValue(self.firstTime, forKey: "firstTime")
    }
}
    
    func removePlayer() {
        if playerCount > 1 {
            
            playerCount -= 1

            if playerCount == 1 {
                let path = Bundle.main.path(forResource: "cheer", ofType: "wav")!
                let url = URL(fileURLWithPath: path)
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: url)
                    audioPlayer?.play()
                } catch {
                    // Error Handling
                }
                
            } else {
                let path = Bundle.main.path(forResource: "aww", ofType: "wav")!
                let url = URL(fileURLWithPath: path)
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: url)
                    audioPlayer?.play()
                } catch {
                    // Error Handling
                }
            }
        }
        
    }
    
    func playSound() {
        let path = Bundle.main.path(forResource: "bell2", ofType: "wav")!
        let url = URL(fileURLWithPath: path)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            // Error Handling
        }
    }
    
    // MARK: Backup Values for resetting the timer
    @Published var currentTimerBackup = 1
    var currentLevelBackup = 1
    var chipStackBackup = 9000
    var smallBlindBackup = 100
    var playerCountBackup = 9
    
    func backUpTimerValues() {
        currentTimerBackup = currentTimer
        currentLevelBackup = currentLevel
        chipStackBackup = chipStack
        smallBlindBackup = smallBlind
        playerCountBackup = playerCount
        
    }
    
    func resetTimerValues() {
        currentTimer = currentTimerBackup
        currentLevel = currentLevelBackup
        chipStack = chipStackBackup
        smallBlind = smallBlindBackup
        playerCount = playerCountBackup
        
    }
    
    

    
    
    func pokerTimerCountdown() {
        if currentTimer > 0 {
            currentTimer -= 1
        } else {
            currentTimer = currentTimerBackup
            currentLevel += 1
            if smallBlind >= blindLimit {
                
                playSound()
                
                return
            } else {
                smallBlind += raiseBlindsBy
                playSound()
            }
            
            
        }
    }
    
}

