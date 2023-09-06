//
//  PayoutsView.swift
//  PokerBlinds
//
//  Created by Adam Reed on 9/6/23.
//

import SwiftUI


struct PayoutsView: View {
    
    @StateObject var payoutsVM = PayoutsViewModel()
    @State var twoPlayerPayoutTotal: String = ""
    @State var playerOnePayout: Int = 0
    @State var playerTwoPayout: Int = 0
    
    var body: some View {
        List {
            Section(header: Text("Payouts calc")) {
                HStack {
                    Stepper("Players \(payoutsVM.players.count)",
                            onIncrement: { payoutsVM.addPlayer() },
                            onDecrement: { payoutsVM.removePlayer() })
                }
                HStack {
                    Text("Starting stack")
                    HStack(spacing: .zero) {
                        Text("$")
                        Text(payoutsVM.startingStack, format: .number)
                        Stepper("", value: $payoutsVM.startingStack, in: 1_000...100_000, step: 1_000)
                    }
                }
                PayoutRowView(place: "Total money", payout: payoutsVM.getTotalMoney())
                PayoutRowView(place: "Prize pool", payout: payoutsVM.getTotalPrizeMoney())
                PayoutRowView(place: "High hand", payout: payoutsVM.highHandPrize)
                PayoutRowView(place: "1st", payout: payoutsVM.firstPlacePrize)
                PayoutRowView(place: "2nd", payout: payoutsVM.secondPlacePrize)
                if payoutsVM.thirdPlacePrize != 0 {
                    PayoutRowView(place: "3rd", payout: payoutsVM.thirdPlacePrize)
                }
            }
            
            Section(header: Text("End game with two players")) {
                Text("Enter either player total")
                TextField(twoPlayerPayoutTotal, text: $twoPlayerPayoutTotal)
                Button("Calculate payout") {
                    
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



struct PayoutRowView: View {
    
    let place: String
    let payout: Int
    
    var body: some View {
        HStack {
            Text(place)
                .font(.caption)
            Spacer()
            HStack(spacing: 0) {
                Text("$")
                Text(payout, format: .number)
            }
        }
    }
}
