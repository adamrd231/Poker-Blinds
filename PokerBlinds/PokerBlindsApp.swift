//
//  PokerBlindsApp.swift
//  PokerBlinds
//
//  Created by Adam Reed on 7/17/21.
//

import SwiftUI
//import GoogleMobileAds
import StoreKit

@main
struct PokerBlindsApp: App {
    
    @StateObject var pokerBlinds = PokerBlinds()
    @StateObject var options = Options()
    @StateObject var storeManager = StoreManager()
    var productIds = ["removePokerAdvertising"]
    
    
    var body: some Scene {
        WindowGroup {
            PokerBlindsView(storeManager: storeManager).environmentObject(pokerBlinds).environmentObject(options)
                .onAppear(perform: {
                    SKPaymentQueue.default().add(storeManager)
                    storeManager.getProducts(productIDs: productIds)
            }) 
        }
    }
}
