//
//  PokerBlindsApp.swift
//  PokerBlinds
//
//  Created by Adam Reed on 7/17/21.
//

import SwiftUI

@main
struct PokerBlindsApp: App {
    
    @StateObject var pokerBlinds = PokerBlinds()
    @StateObject var options = Options()
    
    var body: some Scene {
        WindowGroup {
            PokerBlindsView().environmentObject(pokerBlinds).environmentObject(options)
        }
    }
}
