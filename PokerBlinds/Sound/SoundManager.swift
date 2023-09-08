//
//  SoundManager.swift
//  PokerBlinds
//
//  Created by Adam Reed on 6/12/23.
//

import Foundation
import AVKit

enum SoundFileType: String {
    case mp3 = "mp3"
    case wav = "wav"
    case flac = "flac"
}

struct SoundEffect: Hashable {
    let title: String
    let path: String
    let type: SoundFileType
}

class SoundManager {
    
    static let instance = SoundManager()
    var audioPlayer: AVAudioPlayer?

    var roundEndsFX: [SoundEffect] = [
        SoundEffect(title: "Bell", path: "bell", type: .wav),
        SoundEffect(title: "Three Bells", path: "threeBells", type: .wav),
        SoundEffect(title: "Tada", path: "tada", type: .mp3),
        SoundEffect(title: "Times up", path: "timesUp", type: .wav),
    ]
    
    var tenSecondWarningFX: [SoundEffect] = [
        SoundEffect(title: "Clock", path: "clockTicking", type: .wav),
        SoundEffect(title: "Electronic ticks", path: "electronicTicking", type: .flac)
    ]
    
    // Play sounds!
    func playSound(sound: SoundEffect) {
        let path = Bundle.main.path(forResource: sound.path, ofType: sound.type.rawValue) ?? ""
        let url = URL(fileURLWithPath: path)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch let error {
            print("Error playing sound \(error)")
        }
    }
}
