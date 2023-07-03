//
//  Blinds.swift
//  PokerBlinds
//
//  Created by Adam Reed on 6/5/23.
//

import SwiftUI

struct BlindsView: View {
    
    let previousBlind: BlindLevel?
    let currentBlind: BlindLevel
    let nextBlind: BlindLevel?
    
    var body: some View {
        VStack(alignment: .center) {
            
            if let previous = previousBlind {
                HStack {
                    Text("\(previous.smallBlind)")
                    Text("|")
                    Text("\(previous.bigBlind)")
                }
            }
            
            HStack {
                LargeText(text: "\(currentBlind.smallBlind)", textSize: 60)
                LargeText(text: "|", textSize: 60)
                LargeText(text: "\(currentBlind.bigBlind)", textSize: 60)
            }
            .font(.largeTitle)
            .bold()
            
            if let last = nextBlind {
                HStack {
                    Text("\(last.smallBlind)")
                    Text("|")
                    Text("\(last.bigBlind)")
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct Blinds_Previews: PreviewProvider {
    static var previews: some View {
        BlindsView(
            previousBlind: BlindLevel(smallBlind: 100),
            currentBlind: BlindLevel(smallBlind: 200),
            nextBlind: BlindLevel(smallBlind: 300)
        )
    }
}
