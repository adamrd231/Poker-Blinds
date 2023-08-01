//
//  Blinds.swift
//  PokerBlinds
//
//  Created by Adam Reed on 6/5/23.
//

import SwiftUI

struct BlindsView: View {
    let fontSize: Double
    let vm: ViewModel
    let currentLevel: Int
    
//    let previousBlind: BlindLevel?
//    let currentBlind: BlindLevel
//    let nextBlind: BlindLevel?
    
    var body: some View {
        VStack(alignment: .center) {
            if let previous = vm.blinds.getPreviousBlinds(currentLevel: currentLevel) {
                HStack {
                    Text("\(previous.smallBlind)")
                    Text("|")
                    Text("\(previous.bigBlind)")
                }
            } else {
                Text("Good luck!")
            }
            
            HStack {
                Text("\(vm.blinds.getCurrentBlind(currentLevel: currentLevel).smallBlind)")
                Text("|")
                Text("\(vm.blinds.getCurrentBlind(currentLevel: currentLevel).bigBlind)")
            }
            .font(.system(size: fontSize, weight: .heavy, design: .rounded))
            .minimumScaleFactor(0.1)
            .bold()
            
            if let last = vm.blinds.getNextBlinds(currentLevel: currentLevel) {
                HStack {
                    Text("\(last.smallBlind)")
                    Text("|")
                    Text("\(last.bigBlind)")
                }
            }else {
                Text("no more blinds!")
            }
        }
    }
}

struct Blinds_Previews: PreviewProvider {
    static var previews: some View {
        BlindsView(
            fontSize: 80,
            vm: ViewModel(),
            currentLevel: 0
        )
    }
}
