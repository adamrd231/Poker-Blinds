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
            HStack {
                Text("\(blindInfo.smallBlind - amountToRaiseBlinds)")
                Text("|")
                Text("\((blindInfo.smallBlind - amountToRaiseBlinds) * 2)")
            }
            
            HStack {
                LargeText(text: "\(blindInfo.smallBlind)", huge: false)
                LargeText(text: "|", huge: false)
                LargeText(text: "\(blindInfo.bigBlind)", huge: false)
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
