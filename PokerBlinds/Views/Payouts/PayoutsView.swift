import SwiftUI

let numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.zeroSymbol  = ""
    return formatter
}()

struct PayoutsView: View {
    
    @ObservedObject var storeManager: StoreManager
    @StateObject var payoutsVM = PayoutsViewModel()
    @FocusState private var textFieldIsFocused: Bool

    @State var playerArray = ["1st place", "2nd place"]
    @State var selectedPlayer = "1st place"
    
    func simpleSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }


    var body: some View {
        List {
            Section(header: Text("Options")) {
                HStack {
                    Stepper("Players \(payoutsVM.players.count)",
                        onIncrement: {
                            simpleSuccess()
                            payoutsVM.addPlayer()
                        }, onDecrement: {
                            simpleSuccess()
                            payoutsVM.removePlayer()
                        }
                    )
  
       
                }
                HStack {
                    Stepper("Buy-in $\(payoutsVM.buyIn)", value: $payoutsVM.buyIn, in: 0...1000, step: 1)
                        .onChange(of: payoutsVM.buyIn) { newValue in
                            simpleSuccess()
                        }
                }
                
                VStack {
                    HStack {
                        Text("High hand")
                        Toggle("", isOn: $payoutsVM.isUsingHighHand)
                            .onChange(of: payoutsVM.isUsingHighHand) { newValue in
                                simpleSuccess()
                            }
            
                    }
                    if payoutsVM.isUsingHighHand {
                        Stepper("Cost (less from buy in) $\(payoutsVM.highHandContribution)", value: $payoutsVM.highHandContribution, in: 1...100, step: 1)
                            .onChange(of: payoutsVM.highHandContribution) { newValue in
                                simpleSuccess()
                            }
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
                            .onChange(of: payoutsVM.startingStack) { newValue in
                                simpleSuccess()
                            }
                        
                    }
                }
                Text("Enter final total for either player")
                Text("Players in game \(payoutsVM.players.count)")
                TextField("Enter either player chip total",
                          value: $payoutsVM.splitPotPayout,
                          formatter: numberFormatter
                )
                .focused($textFieldIsFocused)
                .keyboardType(.numberPad)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Button("Dismiss") {
                            simpleSuccess()
                            textFieldIsFocused = false
                        }
                        Button("Calculate") {
                            simpleSuccess()
                            payoutsVM.calculatePayout()
                            textFieldIsFocused = false
                        }
                    }
                }
   
                Button("Calculate payout") {
                    simpleSuccess()
                    payoutsVM.calculatePayout()
                }
                
                if payoutsVM.playerOnePayout != 0 {
                    PayoutRowView(place: "First place", payout: payoutsVM.playerOnePayout)
                }
                if payoutsVM.playerTwoPayout != 0 {
                    PayoutRowView(place: "Second place", payout: payoutsVM.playerTwoPayout)
                }
            }
        }
        .disabled(!storeManager.purchasedNonConsumables.contains(where: { $0.id == StoreIDsConstant.payoutCalculator }))
        .opacity(!storeManager.purchasedNonConsumables.contains(where: { $0.id == StoreIDsConstant.payoutCalculator }) ? 0.5 : 1.0)
    }
}

struct PayoutsView_Previews: PreviewProvider {
    static var previews: some View {
        PayoutsView(storeManager: StoreManager())
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
