//
//  OptionsView.swift
//  PokerBlinds
//
//  Created by Adam Reed on 7/20/21.
//

import SwiftUI

struct OptionsView: View {
    
    // Pokerblinds object with all usable inputs
    @EnvironmentObject var pokerBlinds: PokerBlinds
    @EnvironmentObject var options: Options
    
    @State var currentDate = Date()
    
    func updateOptions() {
        
        
        pokerBlinds.chipStack = options.chipStack
        pokerBlinds.currentTimer = options.currentTimer
        pokerBlinds.playerCount = options.players
        pokerBlinds.playerStartingCount = options.players
        pokerBlinds.blindLimit = options.smallBlindLimit
        pokerBlinds.smallBlind = options.smallBlind
        
    }
    
    func displayCurrentTimer() -> Text {
        if options.currentTimer < 10 {
            return Text("\(options.currentMinutes): 0\(options.currentSeconds)")
        } else {
            return Text("\(options.currentMinutes): \(options.currentSeconds)")
        }
    }
    
    
    var body: some View {
        
        
        List {
            
            // Row ///////////////////////////
            HStack {
                Text("Starting Chips: \(options.chipStack)")
                Stepper("", value: $options.chipStack, in: 100...25000, step: 100)
            }
            
            // Row ///////////////////////////
            HStack {
                Text("Blind Time")
                Stepper((options.currentSeconds < 10 ? "\(options.currentMinutes):0\(options.currentSeconds)" : "\(options.currentMinutes):\(options.currentSeconds)"), value: $options.currentTimer, in: 10...1000, step: 10)
            }
            
            
            
            // Row ///////////////////////////

            HStack {
                Text("Starting Blinds")
                Text("\(options.smallBlind) / \(options.bigBlind)")
                Stepper("", value: $options.smallBlind, in: 25...1000, step: 25)
            }
            
            HStack {
                Text("Blind Limits")
                Text("\(options.smallBlindLimit) / \(options.bigBlindLimit)")
                Stepper("", value: $options.smallBlindLimit, in: 50...5000, step: 100)
            }
                
            
            
            
            // Row ///////////////////////////
            HStack {
                Stepper("Players: \(options.players)", value: $options.players, in: 1...32, step: 1)
            }
            
        }.onDisappear(perform: {
            updateOptions()
        })
        
        
    }
}

struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsView().environmentObject(PokerBlinds()).environmentObject(Options())
    }
}
