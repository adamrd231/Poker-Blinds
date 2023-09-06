//
//  PayoutsView.swift
//  PokerBlinds
//
//  Created by Adam Reed on 9/6/23.
//

import SwiftUI

let numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.zeroSymbol  = ""
    return formatter
}()

struct PayoutsView: View {
    
    @StateObject var payoutsVM = PayoutsViewModel()
    @State var twoPlayerPayoutTotal: String = ""
    @State var twoPlayerPayout = 0
    @State var playerOnePayout: Int = 0
    @State var playerTwoPayout: Int = 0
    @State var playerArray = ["1st place", "2nd place"]
    @State var selectedPlayer = "1st place"

    var body: some View {
        List {
            Section(header: Text("Options")) {
                HStack {
                    Stepper("Players \(payoutsVM.players.count)",
                            onIncrement: { payoutsVM.addPlayer() },
                            onDecrement: { payoutsVM.removePlayer() })
                }
                HStack {
                    Stepper("Buy-in $\(payoutsVM.buyIn)", value: $payoutsVM.buyIn, in: 0...1000, step: 1)
                }
                
                VStack {
                    HStack {
                        Text("High hand")
                        Toggle("", isOn: $payoutsVM.isUsingHighHand)
                    }
                    if payoutsVM.isUsingHighHand {
                        Stepper("Cost (less from buy in) $\(payoutsVM.highHandContribution)", value: $payoutsVM.highHandContribution, in: 1...100, step: 1)
                    }
                }
            }

            Section(header: Text("Payouts calc")) {
                PayoutRowView(place: "Total money", payout: payoutsVM.getTotalMoney())
                if payoutsVM.isUsingHighHand {
                    PayoutRowView(place: "High hand", payout: payoutsVM.highHandPrize)
                }
                PayoutRowView(place: "1st", payout: payoutsVM.firstPlacePrize)
                PayoutRowView(place: "2nd", payout: payoutsVM.secondPlacePrize)
                if payoutsVM.thirdPlacePrize != 0 {
                    PayoutRowView(place: "3rd", payout: payoutsVM.thirdPlacePrize)
                    
                }
                if payoutsVM.isUsingHighHand {
                    PayoutRowView(place: "Prize pool", payout: payoutsVM.getTotalPrizeMoney())
                }
            }
            
            Section(header: Text("End game with two players")) {
                HStack {
                    Text("Starting stack")
                    HStack(spacing: .zero) {
                        Text("$")
                        Text(payoutsVM.startingStack, format: .number)
                        Stepper("", value: $payoutsVM.startingStack, in: 1_000...100_000, step: 1_000)
                    }
                }
                Text("Enter final total for either player")
                TextField("Enter either player chip total", value: $twoPlayerPayout, formatter: numberFormatter)
                Button("Calculate payout") {
  
                    let removeCommas = twoPlayerPayoutTotal.replacingOccurrences(of: ",", with: "")
                    let numberEntered = Double(removeCommas)
                    let percentage = (numberEntered ?? 0) / Double(payoutsVM.players.count * payoutsVM.startingStack)
                    let finalAmount = percentage * Double(payoutsVM.firstPlacePrize + payoutsVM.secondPlacePrize)
                    
                    // Get two values for first and second place
                    if Int(finalAmount) > payoutsVM.firstPlacePrize || Int(finalAmount) < payoutsVM.secondPlacePrize {
                        playerOnePayout = payoutsVM.firstPlacePrize
                        playerTwoPayout = payoutsVM.secondPlacePrize
                    } else {
                        let firstAmount = Int(finalAmount)
                        let secondAmount = (payoutsVM.firstPlacePrize + payoutsVM.secondPlacePrize) - firstAmount
 
                        if firstAmount > secondAmount {
                            playerOnePayout = firstAmount
                            playerTwoPayout = secondAmount
                        } else {
                            playerOnePayout = secondAmount
                            playerTwoPayout = firstAmount
                        }
                    }
                }
                if playerOnePayout != 0 {
                    PayoutRowView(place: "First place", payout: playerOnePayout)
                }
                if playerTwoPayout != 0 {
                    PayoutRowView(place: "Second place", payout: playerTwoPayout)
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
            Spacer()
            HStack(spacing: 0) {
                Text("$")
                Text(payout, format: .number)
            }
            .bold()
        }
    }
}
