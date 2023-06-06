//
//  Blinds.swift
//  PokerBlinds
//
//  Created by Adam Reed on 6/5/23.
//

import SwiftUI

struct BlindsView: View {
    
    let blindsModel: BlindsModel
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Text("\(blindsModel.smallBlind - blindsModel.amountToRaiseBlinds)")
                Text("|")
                Text("\((blindsModel.smallBlind - blindsModel.amountToRaiseBlinds) * 2)")
            }
            
            HStack {
                LargeText(text: "\(blindsModel.smallBlind)", huge: false)
                LargeText(text: "|", huge: false)
                LargeText(text: "\(blindsModel.bigBlind)", huge: false)
            }
            .font(.largeTitle)
            .bold()
            
            HStack {
                Text("\(blindsModel.smallBlind + blindsModel.amountToRaiseBlinds)")
                Text("|")
                Text("\((blindsModel.smallBlind + blindsModel.amountToRaiseBlinds) * 2)")
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct Blinds_Previews: PreviewProvider {
    static var previews: some View {
        BlindsView(blindsModel: BlindsModel(currentLevel: 1, smallBlind: 100, amountToRaiseBlinds: 100))
    }
}
