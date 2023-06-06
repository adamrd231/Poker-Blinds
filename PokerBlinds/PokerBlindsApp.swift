//
//  PokerBlindsApp.swift
//  PokerBlinds
//
//  Created by Adam Reed on 7/17/21.
//

import SwiftUI
import StoreKit
import AppTrackingTransparency

@main
struct PokerBlindsApp: App {
    
    @StateObject var pokerBlinds = PokerBlinds()
    @StateObject var options = Options()
    @StateObject var storeManager = StoreManager()
    var productIds = ["removePokerAdvertising"]
    
    func requestIDFA() {
        ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
            
        })
    }
    
    var body: some Scene {
        WindowGroup {
            PokerBlindsView()
                .onAppear(perform: {
                    SKPaymentQueue.default().add(storeManager)
                    storeManager.getProducts(productIDs: productIds)
                    requestIDFA()
            }) 
        }
    }
}
