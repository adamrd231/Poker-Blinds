//
//  ContentView.swift
//  PokerBlinds
//
//  Created by Adam Reed on 7/17/21.
//

import SwiftUI
import AVFoundation

struct PokerBlindsView: View {
    @StateObject var vm = ViewModel()
    
    var body: some View {
        TabView {
            // MARK: Home Screen
            VStack(alignment: .center) {
                Spacer()
                VStack {
                    TimerView(blinds: vm.blinds, timerInfo: vm.timerInfo)

                    // Show blind information here
                    BlindsView(blindsModel: vm.blinds)
                }
                Spacer()
                HStack(spacing: 5) {
                    Button(vm.timerInfo.isTimerRunning == TimerStates.isRunning ? "Pause" : "Start") {
                        if vm.timerInfo.isTimerRunning == TimerStates.isRunning {
                            vm.pauseTimer()
                        } else {
                            vm.startTimer()
                        }
                    }
                    .buttonStyle(BasicButtonStyle())
                    
                    Button("Reset") {
                        vm.startTimer()
                    }
                    .buttonStyle(BasicButtonStyle())
                    .disabled(vm.timerInfo.isTimerRunning == TimerStates.isRunning)
                }
                .padding()
                    
                if vm.storeManager.purchasedRemoveAds != true {
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
            
            RemoveAdvertising(storeManager: vm.storeManager)
                .tabItem {
                    HStack {
                        Image(systemName: "pip.remove")
                        Text("No Ads")
                    }
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PokerBlindsView()
    }
}

struct BasicButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(height: 50, alignment: .center)
            .frame(maxWidth: .infinity)
            .background(Color(.systemGray))
            .foregroundColor(Color(.systemGray6))
            .cornerRadius(15.0)
    }
}
