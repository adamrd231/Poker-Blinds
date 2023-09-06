//
//  PayoutsView.swift
//  PokerBlinds
//
//  Created by Adam Reed on 9/6/23.
//

import SwiftUI

struct PayoutsView: View {
    
    @StateObject var payoutsVM = PayoutsViewModel()
    
    var body: some View {
        List {
            Section(header: Text("Payouts calc")) {
                HStack {
                    Text("Players")
                    Text(payoutsVM.players.count.description)
                }
                HStack {
                    Text("Total money")
                    Text(payoutsVM.getTotalMoney(), format: .number)
                }
                
                HStack {
                    Text("1st")
                    Text(payoutsVM.firstPlacePrize, format: .number)
                }
                HStack {
                    Text("2nd")
                    Text(payoutsVM.secondPlacePrize, format: .number)
                }
                HStack {
                    Text("3rd")
                    Text(payoutsVM.thirdPlacePrize, format: .number)
                }
                HStack {
                    Text("High Hand")
                    Text(payoutsVM.highHandPrize, format: .number)
                }
                
                Button("Add player") {
                    payoutsVM.addPlayer()
                }
                Button("Remove player") {
                    payoutsVM.removePlayer()
                }
            }
        }
    }
}

struct PayoutsView_Previews: PreviewProvider {
    static var previews: some View {
        PayoutsView()
    }
}
