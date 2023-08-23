//
//  OptionsView.swift
//  PokerBlinds
//
//  Created by Adam Reed on 7/20/21.
//

import SwiftUI

struct OptionRowView: View {
    let text: String
    @Binding var firstValue: Int
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(text)
                    .font(.caption)
                Text(firstValue.description)
                    .font(.title2)
            }
            Spacer()
            Stepper("", value: $firstValue, in: 100...5000, step: 100)
                .fixedSize()
        }
    }
}

struct OptionRowBlindView: View {
    let text: String
    @Binding var blind: Int
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(text)
                    .font(.caption)
                HStack {
                    Text(blind.description)
                    Text("|")
                    Text((blind * 2).description)
                }
                .font(.title2)
            }
            Spacer()
            Stepper("", value: $blind, in: 100...5000, step: 100)
                .fixedSize()
        }
    }
}


struct OptionsView: View {
    // Pokerblinds object with all usable inputs
    @EnvironmentObject var vm: ViewModel
    @ObservedObject var storeManager: StoreManager
    private let titleSize: CGFloat = 25
    
    @State var isPortrait: Bool = true
    
    var body: some View {
        VStack {
            List {
                Section(header: Text("Game settings")) {
                    HStack(spacing: 5) {
                        VStack(alignment: .leading) {
                            Text("Time in round")
                                .font(.caption)
                            HStack(spacing: .zero) {
                                Text(vm.timerInfo.currentMinutes.description)
                                // Seconds
                                Text(":")
                                Text(vm.timerInfo.currentSeconds == 0 ? "00" : vm.timerInfo.currentSeconds.description)
                                
                            }
                            .font(.title2)
                            .fixedSize()
                        }
                        Spacer()
                        Stepper("", value: $vm.timerInfo.currentTime, in: 10...10_000, step: 10)
                            .fixedSize()
                    }
                    
                    OptionRowBlindView(text: "Starting Blinds", blind: $vm.blinds.startingOptions.startingSmallBlind)
                    OptionRowView(text: "Raise blinds by", firstValue: $vm.blinds.startingOptions.amountToRaiseBlinds)
                    OptionRowBlindView(text: "Blind limit", blind: $vm.blinds.startingOptions.blindLimit)
                   
                    VStack {
                        HStack(alignment: .center) {
                            Image(systemName: storeManager.purchasedNonConsumables.contains(where: { $0.id == "quickEndGame" }) ? "lock.open" : "lock")
                            Text("Quick end game")
                            Spacer()
                            Toggle(vm.quickEndGame ? "on" : "off", isOn: $vm.quickEndGame)
                                .font(.caption)
                                .fixedSize()
                        }
                    }
                    .opacity(!storeManager.purchasedNonConsumables.contains(where: { $0.id == "quickEndGame" }) ? 0.5 : 1.0)
                    .disabled(!storeManager.purchasedNonConsumables.contains(where: { $0.id == "quickEndGame" }))
                }

                Section(header: Text("Sound")) {
                    VStack {
                        HStack {
                            Text("End of Round")
                            Spacer()
                            Picker("", selection: $vm.currentSound) {
                                ForEach(SoundManager.instance.roundEndsFX, id: \.self) { index in
                                    Text(index.title)
                                }
                            }
                            .onChange(of: vm.currentSound, perform: { newValue in
                                SoundManager.instance.playSound(sound: vm.currentSound)
                            })
                        }
                    }
                    
     
                    VStack(alignment: .trailing) {
                        HStack {
                            Image(systemName: storeManager.purchasedNonConsumables.contains(where: { $0.id == "roundWarningFeature" }) ? "lock.open" : "lock")
                            Text("Round warning")
                            Spacer()
                            Toggle(vm.usingRoundTimer ? "on" : "off", isOn: $vm.usingRoundTimer)
                                .font(.caption)
                                .fixedSize()
                        }
                       
                        if storeManager.purchasedNonConsumables.contains(where: { $0.id == "roundWarningFeature" }) && vm.usingRoundTimer {
                            Picker("", selection: $vm.roundWarningSound) {
                                ForEach(SoundManager.instance.tenSecondWarningFX, id: \.self) { index in
                                    Text(index.title)
                                }
                            }
                            .fixedSize()
                            .onChange(of: vm.roundWarningSound, perform: { newValue in
                                SoundManager.instance.playSound(sound: vm.roundWarningSound)
                            })
                        }
                    }
                    .opacity(!storeManager.purchasedNonConsumables.contains(where: { $0.id == "roundWarningFeature" }) ? 0.5 : 1.0)
                    .disabled(!storeManager.purchasedNonConsumables.contains(where: { $0.id == "roundWarningFeature" }))
                }
                BlindTable
            }
        }
    }
}

struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsView(storeManager: StoreManager()).environmentObject(ViewModel())
    }
}

extension OptionsView {
    var BlindTable: some View {
        Section(header: HStack {
            Text("Blind Table")
            Spacer()
            Text("prediction: ")
                .font(.system(size: 12))
            ClockLayout(time: vm.totalGameTime , fontSize: 12)
 
        }) {
            ForEach(Array(zip(vm.blinds.blindLevels.indices, vm.blinds.blindLevels)), id: \.0) { index, level in
                HStack {
                    Text("Level \(index + 1)")
                    Rectangle()
                        .foregroundColor(Color.theme.mainButton.opacity(0.5))
                        .frame(height: 1)
                        .padding(.horizontal)
                    
                    Text(level.smallBlind.description)
                    Text("|")
                    Text(level.bigBlind.description)
                }
            }
        }
    }
}
