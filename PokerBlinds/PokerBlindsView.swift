//
//  ContentView.swift
//  PokerBlinds
//
//  Created by Adam Reed on 7/17/21.
//

import SwiftUI
import AVFoundation
import GoogleMobileAds

struct PokerBlindsView: View {
    @StateObject var vm = ViewModel()



    

    func startButtonText() -> Text {
        switch vm.pokerGame.isTimerRunning {
            case .hasNotBeenStarted: return Text("Start")
            case .isPaused: return Text("Re-Start")
            case .isRunning: return Text("Pause")
        }
    }
    
    var body: some View {
        TabView {
            // MARK: Home Screen
            VStack(alignment: .center) {
                List {
                    Section(header: Text("Timer")) {
                        TimerView()
                    }
                    
                    Section(header: Text("Blinds")) {
                        // Show blind information here
                        BlindsView(smallBlind: vm.pokerGame.blindsModel.smallBlind, bigBlind: vm.pokerGame.blindsModel.bigBlind, raiseBlindsValue: vm.pokerGame.blindsModel.amountToRaiseBlinds)
                    }
                }
                .listStyle(.plain)

                HStack(spacing: 5) {
                    Button(action: {
                        // Start / Pause button
    
                    }) {
                        startButtonText()
                            .frame(height: 50, alignment: .center)
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemGray))
                            .foregroundColor(Color(.systemGray6))
                            .cornerRadius(15.0)
                    }
                    
                    Button(action: {
  
                    }) {
                        Text("Reset")
                            .frame(height: 50, alignment: .center)
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemGray))
                            .foregroundColor(Color(.systemGray6))
                            .cornerRadius(15.0)
                    }
                }
                .padding()
                    
                if storeManager.purchasedRemoveAds != true {
                    Banner()
                }
            }
            .tabItem {
                HStack {
                    Image(systemName: "house")
                    Text("Home")
                }
            }
            
            // MARK: Second Screen
            OptionsView()
                .tabItem {
                    HStack {
                        Image(systemName: "option")
                        Text("Options")
                    }
                }
            
            RemoveAdvertising(storeManager: storeManager)
                .tabItem {
                    HStack {
                        Image(systemName: "pip.remove")
                        Text("No Ads")
                    }
                }
                .onReceive(timer, perform: { _ in
    
                })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PokerBlindsView(storeManager: StoreManager())
            .environmentObject(PokerBlinds())
            .environmentObject(Options())
    }
}
