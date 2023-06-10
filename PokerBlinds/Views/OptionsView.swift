//
//  OptionsView.swift
//  PokerBlinds
//
//  Created by Adam Reed on 7/20/21.
//

import SwiftUI

struct OptionsView: View {
    
    // Pokerblinds object with all usable inputs
    @EnvironmentObject var vm: ViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Options")
                .font(.system(size: 20, weight: .heavy, design: .rounded))
            
            Divider()
                .padding(.bottom)
            HStack {
                Text("Time in round")
                if vm.timerInfo.currentSeconds == 0 {
                    Stepper("\(vm.timerInfo.currentMinutes.description):00", value: $vm.timerInfo.currentTime, in: 1...1000, step: 10)
                } else {
                    Stepper("\(vm.timerInfo.currentMinutes.description):\(vm.timerInfo.currentSeconds)", value: $vm.timerInfo.currentTime, in: 1...1000, step: 10)
                }
       
            }
            
            HStack {
                Text("Starting Blinds")
                Text(vm.blindInfo.startingSmallBlind.description)
                Text("|")
                Text((vm.blindInfo.startingSmallBlind * 2).description)
                Stepper("", value: $vm.blindInfo.startingSmallBlind, in: 100...5000, step: 100)
            }
            
            HStack {
                Text("Raise blinds by")
                Text(vm.blindInfo.amountToRaiseBlinds.description)
      
                Stepper("", value: $vm.blindInfo.amountToRaiseBlinds, in: 100...5000, step: 100)
                
            }
            
            HStack {
                Text("Blind limit")
                Text(vm.blindInfo.blindLimit.description)
                Text("|")
                Text((vm.blindInfo.blindLimit * 2).description)
                Stepper("", value: $vm.blindInfo.blindLimit, in: 100...5000, step: 100)
            }
            Divider()
            ScrollView {
                ForEach(Array(vm.blindsArray.enumerated()), id: \.offset) { index, level in
                    HStack(alignment: .center) {
                        Text("Level \((index + 1).description)")
                        Text("-")
                        Text(level.smallBlind.description)
                        Text("|")
                        Text(level.bigBlind.description)
                        Spacer()
                    }
                    .background(index % 2 == 0 ? .gray.opacity(0.25) : .clear)

                    
                }
            }
           
            HStack(spacing: .pi) {
                Text("\(vm.totalGameTime.0)")
                Text(":")
                if vm.totalGameTime.1 == 0 {
                    Text("00")
                } else {
                    Text("\(vm.totalGameTime.1)")
                }
            }
            .bold()
            
            
            Spacer()
        }
        .padding()
    }
}

struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsView().environmentObject(ViewModel())
    }
}
