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
            Text(text)
            Spacer()
            Text(firstValue.description)
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
            Text(text)
            Spacer()
            Text(blind.description)
            Text("|")
            Text((blind * 2).description)
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
                    HStack {
                        Text("Time in round")
                        Spacer()
                        HStack(spacing: .zero) {
                            // Minutes
                            Text(vm.timerInfo.currentMinutes.description)
                           // Seconds
                            Text(":")
                            Text(vm.timerInfo.currentSeconds == 0 ? "00" : vm.timerInfo.currentSeconds.description)
                        }
                        Stepper("", value: $vm.timerInfo.currentTime, in: 10...1000, step: 10)
                            .fixedSize()
                    }
                    
                    OptionRowBlindView(text: "Starting Blinds", blind: $vm.blindInfo.startingSmallBlind)
                    OptionRowView(text: "Raise blinds by", firstValue: $vm.blindInfo.amountToRaiseBlinds)
                    OptionRowBlindView(text: "Blind limit", blind: $vm.blindInfo.blindLimit)
                }

                Section(header: Text("Sound")) {
                    HStack {
                        Text("End of Round")
                        Spacer()
                        Picker("", selection: $vm.currentSound) {
                            ForEach(SoundManager.instance.allSounds.indices, id: \.self) { index in
                                Text(SoundManager.instance.allSounds[index].rawValue)
                            }
                        }
                        .onChange(of: vm.currentSound, perform: { newValue in
                            SoundManager.instance.playSound(sound: SoundManager.instance.allSounds[vm.currentSound])
                        })
                    }
                    HStack {
                        Toggle("", isOn: $vm.usingRoundTimer)
                            .fixedSize()
                        Text("Round warning")
                        Spacer()
                        Picker("", selection: $vm.roundWarningSound) {
                            ForEach(SoundManager.instance.allSounds.indices, id: \.self) { index in
                                Text(SoundManager.instance.allSounds[index].rawValue)
                            }
                        }
                        .onChange(of: vm.currentSound, perform: { newValue in
                            SoundManager.instance.playSound(sound: SoundManager.instance.allSounds[vm.currentSound])
                        })
                    }
                    .disabled(storeManager.roundWarningUnlocked != true)
                    .foregroundColor(storeManager.roundWarningUnlocked != true ? .gray : .black)
                    
                }
                
                Section(header: Text("Blind table")) {
                        ForEach(Array(zip(vm.blindsArray.indices, vm.blindsArray)), id: \.0) { index, level in
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
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            guard let scene = UIApplication.shared.windows.first?.windowScene else { return }
            self.isPortrait = scene.interfaceOrientation.isPortrait
        }
    }
}

struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsView(storeManager: StoreManager()).environmentObject(ViewModel())
    }
}
