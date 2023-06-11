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
                .bold()
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
                .bold()
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
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Options")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(Color.theme.mainButton)
                
                Divider()
                    .padding(.bottom)
                
                HStack {
                    Text("Time in round")
                        .bold()
                    Spacer()
                    HStack(spacing: .zero) {
                        // Minutes
                        Text(vm.timerInfo.currentMinutes.description)
                       // Seconds
                        Text(":")
                        Text(vm.timerInfo.currentSeconds == 0 ? "00" : vm.timerInfo.currentSeconds.description)
                    }
                    Stepper("", value: $vm.timerInfo.currentTime, in: 1...1000, step: 10)
                        .fixedSize()
        
                }
                OptionRowBlindView(text: "Starting Blinds", blind: $vm.blindInfo.startingSmallBlind)
                OptionRowView(text: "Raise blinds by", firstValue: $vm.blindInfo.amountToRaiseBlinds)
                
                HStack {
                    Text("Blind limit")
                        .bold()
                    Spacer()
                    Text(vm.blindInfo.blindLimit.description)
                    Text("|")
                    Text((vm.blindInfo.blindLimit * 2).description)
                    Stepper("", value: $vm.blindInfo.blindLimit, in: 100...5000, step: 100)
                        .fixedSize()
                }
            }
            .padding()
            
            Divider()
            

            List {
                Section(header: Text("Blind Table")) {
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
            .frame(width: UIScreen.main.bounds.width)
            
        }
    }
}

struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsView().environmentObject(ViewModel())
    }
}
