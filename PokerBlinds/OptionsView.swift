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
                .font(.largeTitle)
                .fontWeight(.heavy)
            HStack {
                Text("Time in round")
                Stepper("\(vm.timerInfo.currentTime.description) seconds", value: $vm.timerInfo.currentTime, in: 1...1000)
            }
        }
        .padding()
    }
}

struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsView().environmentObject(ViewModel())
    }
}
