//
//  Blinds.swift
//  PokerBlinds
//
//  Created by Adam Reed on 6/5/23.
//

import SwiftUI

struct BlindsView: View {
    
    let smallBlind: Int
    let bigBlind: Int
    let raiseBlindsValue: Int
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Text("\(smallBlind - raiseBlindsValue)")
                Text("|")
                Text("\((smallBlind - raiseBlindsValue) * 2)")
            }
            .font(.caption)
            
            HStack {
                Text("\(smallBlind)")
                Text("|").font(.title3)
                Text("\(bigBlind)")
            }
            .font(.largeTitle)
            .bold()
            
            HStack {
                Text("\(smallBlind + raiseBlindsValue)")
                Text("|")
                Text("\((smallBlind + raiseBlindsValue) * 2)")
            }
            .font(.caption)
        }
        .frame(maxWidth: .infinity)
    }
}

struct Blinds_Previews: PreviewProvider {
    static var previews: some View {
        BlindsView(smallBlind: 100, bigBlind: 200, raiseBlindsValue: 100)
    }
}
