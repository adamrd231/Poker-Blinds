//
//  Blinds.swift
//  PokerBlinds
//
//  Created by Adam Reed on 6/5/23.
//

import SwiftUI

struct BlindsView: View {
    
    let blindInfo: BlindLevel
    let amountToRaiseBlinds: Int
    let lastBlind: Bool
    
    var body: some View {
        VStack(alignment: .center) {
            
            if blindInfo.smallBlind - amountToRaiseBlinds != 0 {
                HStack {
                    Text("\(blindInfo.smallBlind - amountToRaiseBlinds)")
                    Text("|")
                    Text("\((blindInfo.smallBlind - amountToRaiseBlinds) * 2)")
                }
            }
            
            HStack {
                LargeText(text: "\(blindInfo.smallBlind)", textSize: 60)
                LargeText(text: "|", textSize: 60)
                LargeText(text: "\(blindInfo.bigBlind)", textSize: 60)
            }
            .font(.largeTitle)
            .bold()
            
            if !lastBlind {
                HStack {
                    Text("\(blindInfo.smallBlind + amountToRaiseBlinds)")
                    Text("|")
                    Text("\((blindInfo.smallBlind + amountToRaiseBlinds) * 2)")
                }
            }
            
        }
        .frame(maxWidth: .infinity)
    }
}

struct Blinds_Previews: PreviewProvider {
    static var previews: some View {
        BlindsView(blindInfo: BlindLevel(smallBlind: 100), amountToRaiseBlinds: 100, lastBlind: true)
    }
}
