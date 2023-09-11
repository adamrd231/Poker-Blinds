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
    let function: () -> Void
    
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
                .onChange(of: firstValue) { newValue in
                    function()
                }
        }
    }
}

struct OptionRowBlindView: View {
    let text: String
    @Binding var blind: Int
    let function: () -> Void
    
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
                .onChange(of: blind) { newValue in
                    function()
                }
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
                    TimePickerTimerView(vm: vm)
                  
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Time in round")
                                .font(.caption)
                            HStack {
                                ClockLayout(time: vm.timerInfo.currentTime, fontSize: 20, fontWeight: .regular)
                            }
                            .font(.title2)
                        }
                    }
  
                    OptionRowBlindView(text: "Starting Blinds", blind: $vm.blindGameOptions.startingSmallBlind, function: vm.simpleSuccess)
                    OptionRowView(text: "Raise blinds by", firstValue: $vm.blindGameOptions.amountToRaiseBlinds, function: vm.simpleSuccess)
                    OptionRowBlindView(text: "Blind limit", blind: $vm.blindGameOptions.blindLimit, function: vm.simpleSuccess)
                   
                    VStack {
                        HStack(alignment: .center) {
                            Image(systemName: storeManager.purchasedNonConsumables.contains(where: { $0.id == StoreIDsConstant.quickEndGame }) ? "lock.open" : "lock")
                            Text("Quick end game")
                            Spacer()
                            Toggle(vm.quickEndGame ? "on" : "off", isOn: $vm.quickEndGame)
                                .font(.caption)
                                .fixedSize()
                                .onChange(of: vm.quickEndGame) { newValue in
                                    vm.simpleSuccess()
                                }
                        }
                    }
                    .opacity(!storeManager.purchasedNonConsumables.contains(where: { $0.id == StoreIDsConstant.quickEndGame }) ? 0.5 : 1.0)
                    .disabled(!storeManager.purchasedNonConsumables.contains(where: { $0.id == StoreIDsConstant.quickEndGame }))
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
                                vm.simpleSuccess()
                            })
                        }
                    }
                    
                    VStack(alignment: .trailing) {
                        HStack {
                            Image(systemName: storeManager.purchasedNonConsumables.contains(where: { $0.id == StoreIDsConstant.roundWarningFeature }) ? "lock.open" : "lock")
                            Text("Round warning")
                            Spacer()
                            Toggle(vm.usingRoundTimer ? "on" : "off", isOn: $vm.usingRoundTimer)
                                .font(.caption)
                                .fixedSize()
                                .onChange(of: vm.usingRoundTimer) { newValue in
                                    vm.simpleSuccess()
                                }
                        }
                       
                        if storeManager.purchasedNonConsumables.contains(where: { $0.id == StoreIDsConstant.roundWarningFeature }) && vm.usingRoundTimer {
                            HStack {
                                Text("Selected round sound:")
                                Spacer()
                                Picker("", selection: $vm.roundWarningSound) {
                                    ForEach(SoundManager.instance.tenSecondWarningFX, id: \.self) { index in
                                        Text(index.title)
                                    }
                                }
                                .fixedSize()
                                .onChange(of: vm.roundWarningSound, perform: { newValue in
                                    SoundManager.instance.playSound(sound: vm.roundWarningSound)
                                    vm.simpleSuccess()
                                })
                            }
                        }
                    }
                    .opacity(!storeManager.purchasedNonConsumables.contains(where: { $0.id == StoreIDsConstant.roundWarningFeature }) ? 0.5 : 1.0)
                    .disabled(!storeManager.purchasedNonConsumables.contains(where: { $0.id == StoreIDsConstant.roundWarningFeature }))
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
            ClockLayout(time: vm.totalGameTime, fontSize: 12)
 
        }) {
            ForEach(Array(zip(vm.blindLevels.indices, vm.blindLevels)), id: \.0) { index, level in
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
