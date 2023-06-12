//
//  PokerBlindModel.swift
//  PokerBlinds
//
//  Created by Adam Reed on 7/17/21.
//

import SwiftUI
import AVFoundation
import Foundation

struct Blinds {
    var levels: [BlindLevel]
}

struct BlindLevel: Hashable, Identifiable {
    var id = UUID()
    var smallBlind: Int
    var bigBlind: Int {
        return smallBlind * 2
    }
}

struct BlindsModel {
    var startingSmallBlind: Int
    var amountToRaiseBlinds: Int
    var blindLimit: Int
}

struct TimerModel {
    var currentLevel: Int
    var currentTime: Int
    var currentSeconds: Int {
        return currentTime % 60
    }
    var currentMinutes: Int {
        return currentTime / 60
    }
}

struct PokerGameModel: Identifiable {
    // Timer info
    var id = UUID()
   
    // Blinds info
    var blindsModel: BlindsModel

}

func getTotalGameTime(roundTime: Int, numberOfRounds: Int) -> (min: String, sec: String) {
    let totalTime = roundTime * numberOfRounds
    return ((totalTime / 60).description, (totalTime % 60).description)
}




// MARK: OLD STUFF TO BE DELETED EVENTUALLY
class PokerBlinds: ObservableObject, Identifiable {
    
    var audioPlayer: AVAudioPlayer?
    
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
    
    
}

