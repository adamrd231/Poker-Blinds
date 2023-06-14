//
//  SoundManager.swift
//  PokerBlinds
//
//  Created by Adam Reed on 6/12/23.
//

import Foundation
import AVKit

class SoundManager {
    
    static let instance = SoundManager()
    
    var audioPlayer: AVAudioPlayer?
    // Play sounds!
    
    var allSounds:[FreeSounds] = [
        .bell,
        .aww,
        .cheer,
        .tada,
        .bonk,
        .hitSomething,
        .woodSlam
    ]

    func playSound(sound: FreeSounds) {
        print("playing class")
        var path = ""
        if sound == .tada || sound == .bonk || sound == .woodSlam || sound == .hitSomething {
            path = Bundle.main.path(forResource: sound.rawValue, ofType: "mp3") ?? ""
        } else {
            path = Bundle.main.path(forResource: sound.rawValue, ofType: "wav") ?? ""
        }
       
        let url = URL(fileURLWithPath: path)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch let error {
            print("Error playing sound \(error)")
        }
    }
    
    enum FreeSounds: String {
        case bell = "bell"
        case aww = "aww"
        case cheer = "cheer"
        case tada = "tada"
        case bonk = "bonk"
        case hitSomething = "hitSomething"
        case woodSlam = "woodSlam"
    }
}
