//
//  ContentView.swift
//  PokerBlinds
//
//  Created by Adam Reed on 7/17/21.
//

import SwiftUI
import AVFoundation

struct PokerBlindsView: View {
    // Pokerblinds object with all usable inputs
    @EnvironmentObject var pokerBlinds: PokerBlinds
    @EnvironmentObject var options: Options
    
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
                    
                    
                    
                }.navigationBarTitle("Price of Poker")
                
            }
            .tabItem { HStack { Text("Home") }}
            .tag(0)
            
            // Second Screen
            NavigationView {
                OptionsView().navigationBarTitle("Options")
            }
            .tabItem { Text("Options") }
            .tag(1)
               
             // Close Tab View
            }
            .onReceive(timer, perform: { _ in
                    pokerBlinds.pokerTimerCountdown()
                })
            .onAppear(perform: {
                pokerBlinds.currentTimerBackup = pokerBlinds.currentTimer
                })
        }

    } // Close some View
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PokerBlindsView().environmentObject(PokerBlinds()).environmentObject(Options())
    }
}
