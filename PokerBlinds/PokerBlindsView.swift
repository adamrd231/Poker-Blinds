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
                Text(vm.isTimerRunning.description)
                HStack(spacing: 5) {
                    Button(vm.isTimerRunning == TimerStates.isRunning ? "Pause" : "Start") {
                        vm.isTimerRunning == TimerStates.isRunning ? vm.pauseTimer() : vm.startTimer()
                    }
                    .buttonStyle(BasicButtonStyle())
                    
                    Button("Reset") {
                        vm.resetTimer()
                    }
                    .buttonStyle(BasicButtonStyle())
                    .disabled(vm.isTimerRunning == TimerStates.isRunning)
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
        MainButton(configuration: configuration)
            
            
    }
    
    struct MainButton: View {
        let configuration: ButtonStyle.Configuration
        @Environment(\.isEnabled) private var isEnabled: Bool
        var body: some View {
            configuration.label
                .frame(height: 50, alignment: .center)
                .frame(maxWidth: .infinity)
                .background(isEnabled ? Color(.blue) : Color(.blue).opacity(0.3))
                .foregroundColor(.white)
                .cornerRadius(20.0)
        }
    }
}


