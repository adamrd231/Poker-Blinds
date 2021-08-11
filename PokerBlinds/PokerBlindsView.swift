//
//  ContentView.swift
//  PokerBlinds
//
//  Created by Adam Reed on 7/17/21.
//

import SwiftUI
import AVFoundation
import GoogleMobileAds
import AppTrackingTransparency

struct PokerBlindsView: View {
    // Pokerblinds object with all usable inputs
    @EnvironmentObject var pokerBlinds: PokerBlinds
    @EnvironmentObject var options: Options
    
    // Google Admob variables
    @State var interstitial: GADInterstitialAd?
    @State var playedInterstitial = true
    
    // Timer object
    @State var timer = Timer.publish(every: 1, on: .main, in: .common)
    
    func startPokerTimer() {
        pokerBlinds.backUpTimerValues()
        pokerBlinds.timerIsRunning = true
        pokerBlinds.timerIsPaused = false

        timer = Timer.publish(every: 1, on: .main, in: .common)
        timer.connect()
    }
    
    func unPausePokerTimer() {
        pokerBlinds.timerIsRunning = true
        pokerBlinds.timerIsPaused = false

        timer = Timer.publish(every: 1, on: .main, in: .common)
        timer.connect()
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
    
    
    func requestIDFA() {
      ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
        // Tracking authorization completed. Start loading ads here.

            if playedInterstitial == false {
                let request = GADRequest()
                    GADInterstitialAd.load(withAdUnitID:"ca-app-pub-4186253562269967/2135766372",
                            request: request, completionHandler: { [self] ad, error in
                                // Check if there is an error
                                if let error = error {
                                    return
                                }
                                // If no errors, create an ad and serve it
                                interstitial = ad
                                let root = UIApplication.shared.windows.first?.rootViewController
                                    self.interstitial!.present(fromRootViewController: root!)
                                    // Let user use the app until the next time ad free
                                    playedInterstitial = true
                                }
                            )
                                } else {
                                    return
                                }

      })
    }
    
    var body: some View {
        GeometryReader { geo in
            TabView {
            NavigationView {

                VStack(alignment: .center) {
                    TimerView()
                    VStack(spacing: 7) {
                        Button(action: {
                            if pokerBlinds.timerIsRunning == false {
                                startPokerTimer()
                            } else if pokerBlinds.timerIsRunning == true && pokerBlinds.timerIsPaused == false {
                                pausePokerTimer()
                            } else {
                                unPausePokerTimer()
                            }
                        }) {
                            startButtonText()
                                .frame(width: 100, height: 50, alignment: .center)
                                .background(Color(.systemGray))
                                .foregroundColor(Color(.systemGray6))
                                .cornerRadius(15.0)
                        }
                        
                        Button(action: {
                            stopPokerTimer()
                        }) {
                            Text("Reset")
                                .frame(width: 100, height: 50, alignment: .center)
                                .background(Color(.systemGray))
                                .foregroundColor(Color(.systemGray6))
                                .cornerRadius(15.0)
                        }
                        
                        Button(action: {
                            pokerBlinds.removePlayer()
                        }) {
                            (pokerBlinds.timerIsRunning) ? Text("Remove Player").foregroundColor(Color(.systemGray)) : Text("Remove Player").foregroundColor(Color(.systemGray3))
                            
                            
                        }.disabled(!pokerBlinds.timerIsRunning)
                            
                    }.padding(.top)
                    
                    Banner()
                    
                }
                
            }
            .tabItem { HStack {
                Image(systemName: "house")
                Text("Home")
                
            }}
            .tag(0)
            
            // Second Screen
                if !pokerBlinds.timerIsRunning {
                    NavigationView {
                        OptionsView().navigationBarTitle("Options")
                    }
                    .tabItem { HStack {
                        Image(systemName: "option")
                        Text("Options")
                    } }
                }
           
            
               
             // Close Tab View
            }
            .onReceive(timer, perform: { _ in
                    pokerBlinds.pokerTimerCountdown()
                })
            .onAppear(perform: {
                pokerBlinds.currentTimerBackup = pokerBlinds.currentTimer
                requestIDFA()
                })
        }

    } // Close some View
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PokerBlindsView().environmentObject(PokerBlinds()).environmentObject(Options())
    }
}
