//
//  SoundManager.swift
//  PokerBlinds
//
//  Created by Adam Reed on 6/12/23.
//

import Foundation
import AVKit

struct SoundEffect: Hashable {
    let title: String
    let path: String
    let type: String
}


class SoundManager {
    
    static let instance = SoundManager()
    
    var audioPlayer: AVAudioPlayer?
    // Play sounds!
    
    enum SoundFileType: String {
        case mp3 = "mp3"
        case wav = "wav"
    }
    
    
    var roundEndsFX: [SoundEffect] = [
        SoundEffect(title: "Bell", path: "bell", type: "wav"),
        SoundEffect(title: "Three Bells", path: "threeBells", type: "wav"),
        SoundEffect(title: "Tada", path: "tada", type: "mp3")
    ]
    
    
    var allSounds:[FreeSounds] = [
        .bell,
        .aww,
        .cheer,
        .tada,
        .bonk,
        .bang,
        .slam,
        .timesUp,
        .clockTicking,
        .retroChime,
        .threeBells
    ]

    func playSound(sound: SoundEffect) {
        let path = Bundle.main.path(forResource: sound.path, ofType: sound.type) ?? ""
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
        case bang = "bang"
        case slam = "slam"
        case timesUp = "timesUp"
        case retroChime = "retroChime"
        case threeBells = "threeBells"
        case clockTicking = "clockTicking"
    }
}
