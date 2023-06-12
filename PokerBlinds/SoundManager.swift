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
    
    var allSounds:[FreeSounds] = [.bell2, .aww, .cheer]

    func playSound(sound: FreeSounds) {
        print("playing class")
        guard let path = Bundle.main.path(forResource: "bell2", ofType: "wav") else { return }
        let url = URL(fileURLWithPath: path)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch let error {
            print("Error playing sound \(error)")
        }
    }
    
    enum FreeSounds: String {
        case bell2 = "bell2"
        case aww = "aww"
        case cheer = "cheer"
    }
}
