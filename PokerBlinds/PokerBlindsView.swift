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
                List {
                    Section(header: Text("Timer")) {
                        TimerView(blinds: vm.blinds, timerInfo: vm.timerInfo)
                    }
                    
                    Section(header: Text("Blinds")) {
                        // Show blind information here
                        BlindsView(blindsModel: vm.blinds)
                    }
                }
                .listStyle(.plain)

                HStack(spacing: 5) {
                    Button("Start") {
                        vm.startTimer()
                    }
                    .buttonStyle(BasicButtonStyle())
                    .disabled(vm.timerInfo.isTimerRunning == TimerStates.isRunning)
                   
                    
                    Button(action: {
                        vm.stopTimer()
                    }) {
                        Text("Reset")
                            .buttonStyle(BasicButtonStyle())
                    }
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
