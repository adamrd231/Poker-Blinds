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
    // Pokerblinds object with all usable inputs
    @EnvironmentObject var pokerBlinds: PokerBlinds
    @EnvironmentObject var options: Options
    @StateObject var storeManager: StoreManager
    
    // Google Admob variables
    @State var interstitial: GADInterstitialAd?
    @State var playedInterstitial = false
    
    // Timer object
    @State var timer = Timer.publish(every: 1, on: .main, in: .common)
    
    func pressedStartPauseButton() {
        if pokerBlinds.timerIsRunning == false {
            startPokerTimer()
        } else if pokerBlinds.timerIsRunning == true && pokerBlinds.timerIsPaused == false {
            pausePokerTimer()
        } else {
            unPausePokerTimer()
        }
    }
    
    func startPokerTimer() {
        pokerBlinds.backUpTimerValues()
        pokerBlinds.timerIsRunning = true
        pokerBlinds.timerIsPaused = false
        
        timer = Timer.publish(every: 1, on: .main, in: .common)
        _ = timer.connect()
    }
    
    func unPausePokerTimer() {
        pokerBlinds.timerIsRunning = true
        pokerBlinds.timerIsPaused = false
        
        timer = Timer.publish(every: 1, on: .main, in: .common)
        _ = timer.connect()
    }
    
    func pausePokerTimer() {
        // Stop running the timer
        pokerBlinds.timerIsPaused = true
        self.timer.connect().cancel()
        
    }
    
    func stopPokerTimer() {
        pokerBlinds.resetTimerValues()
        pokerBlinds.timerIsRunning = false
        pokerBlinds.timerIsPaused = false
        self.timer.connect().cancel()
    }
    
    func startButtonText() -> Text {
        if pokerBlinds.timerIsRunning == false {
            return Text("Start")
        } else if pokerBlinds.timerIsRunning == true && pokerBlinds.timerIsPaused == true {
            return Text("Re-Start")
        } else {
            return Text("Pause")
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
                        Blinds(smallBlind: pokerBlinds.smallBlind, bigBlind: pokerBlinds.bigBlind, raiseBlindsValue: pokerBlinds.raiseBlindsBy)
                    }
                }
                .listStyle(.plain)

                HStack(spacing: 5) {
                    Button(action: {
                        // Start / Pause button
                        pressedStartPauseButton()
                    }) {
                        startButtonText()
                            .frame(height: 50, alignment: .center)
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemGray))
                            .foregroundColor(Color(.systemGray6))
                            .cornerRadius(15.0)
                    }
                    
                    Button(action: {
                        stopPokerTimer()
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
            if !pokerBlinds.timerIsRunning {
                OptionsView()
                    .tabItem {
                        HStack {
                            Image(systemName: "option")
                            Text("Options")
                        }
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
                    pokerBlinds.pokerTimerCountdown()
                })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PokerBlindsView(storeManager: StoreManager()).environmentObject(PokerBlinds()).environmentObject(Options())
    }
}
