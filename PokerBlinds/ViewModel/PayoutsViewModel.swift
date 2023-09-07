//
//  PayoutsViewModel.swift
//  PokerBlinds
//
//  Created by Adam Reed on 9/6/23.
//

import Foundation
import UIKit
import Combine

extension BinaryInteger {
  func roundedTowardZero(toMultipleOf m: Self) -> Self {
    return self - (self % m)
  }
  
  func roundedAwayFromZero(toMultipleOf m: Self) -> Self {
    let x = self.roundedTowardZero(toMultipleOf: m)
    if x == self { return x }
    return (m.signum() == self.signum()) ? (x + m) : (x - m)
  }
  
  func roundedDown(toMultipleOf m: Self) -> Self {
    return (self < 0) ? self.roundedAwayFromZero(toMultipleOf: m)
                      : self.roundedTowardZero(toMultipleOf: m)
  }
  
  func roundedUp(toMultipleOf m: Self) -> Self {
    return (self > 0) ? self.roundedAwayFromZero(toMultipleOf: m)
                      : self.roundedTowardZero(toMultipleOf: m)
  }
}


struct Player: Identifiable {
    let id = UUID()
    var startingChips: Int = 10_000
}

class PayoutsViewModel: ObservableObject {
    @Published var players: [Player] = [Player(), Player(), Player(), Player(), Player()]
    @Published var firstPlacePrize: Int = 0
    @Published var secondPlacePrize: Int = 0
    @Published var thirdPlacePrize: Int = 0
    @Published var highHandPrize: Int = 0
    @Published var startingStack: Int = 10_000
    @Published var buyIn: Int = 30
    
    @Published var isUsingHighHand: Bool = false
    @Published var highHandContribution:Int = 5

    
    // Payouts stuff
    @Published var splitPotPayout:Int = 0
    @Published var playerOnePayout: Int = 0
    @Published var playerTwoPayout: Int = 0
    
    
    // Cancellable for subscribers
    private var cancellable = Set<AnyCancellable>()
    
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    
    func calculatePayout() {
        let payoutAmount = Double(splitPotPayout)
        let totalChips = Double(startingStack * players.count)
        let firstAndSecondPrizePool =  Double(firstPlacePrize + secondPlacePrize)
        let percentage = payoutAmount / totalChips
        let finalAmount = percentage * firstAndSecondPrizePool
        
        // Get two values for first and second place
        if Int(finalAmount) > firstPlacePrize || Int(finalAmount) < secondPlacePrize {
            print("Preset")
            playerOnePayout = firstPlacePrize
            playerTwoPayout = secondPlacePrize
        } else {
            print("not preset")
            let firstAmount = Int(finalAmount)
            let secondAmount = (firstPlacePrize + secondPlacePrize) - firstAmount
            
            if firstAmount > secondAmount {
                
                playerOnePayout = firstAmount
                playerTwoPayout = secondAmount
            } else {
                
                playerOnePayout = secondAmount
                playerTwoPayout = firstAmount
            }
        }
        dismissKeyboard()
    }
    
    func getTotalPrizeMoney() -> Int {
        let playerCount = players.count
        let highHandMoney = playerCount * highHandContribution
        if isUsingHighHand {
            return (playerCount * buyIn) - highHandMoney
        } else {
            return playerCount * buyIn
        }
        
    }
    
    func getTotalMoney() -> Int {
        let playerCount = players.count
        return playerCount * buyIn
    }
    
    
    init() {
        subscribers()
    }
    
    func subscribers() {
        $players
            .combineLatest($isUsingHighHand, $buyIn, $highHandContribution)
            .map(mapPayoutInfoToStuff)
            .sink { [weak self] (gameStuff, highHandStuff) in
                self?.distributeMoney(returnedPlayers: gameStuff.0, usingHighHand: highHandStuff.0, gameBuyIn: gameStuff.1, highHandBuyIn: highHandStuff.1)
            }
            .store(in: &cancellable)
    }

    
    func mapPayoutInfoToStuff(players: [Player], isUsingHighHand: Bool, buyIn: Int, highHandBuyIn: Int) -> (([Player], Int), (Bool, Int)) {
        let gameStuff = (players, buyIn)
        let highHandStuff = (isUsingHighHand, highHandBuyIn)
        return (gameStuff, highHandStuff)
    }
    
    // Returns money for first, second and if enough players, third place
    func distributeMoney(returnedPlayers: [Player], usingHighHand: Bool, gameBuyIn: Int, highHandBuyIn: Int) {
        
        var totalMoney = 0
        if usingHighHand {
            totalMoney = (returnedPlayers.count * gameBuyIn) - (returnedPlayers.count * highHandBuyIn)
        } else {
            totalMoney = (returnedPlayers.count * gameBuyIn)
        }
        
        if returnedPlayers.count > 6 {
            let firstPrize = Double(totalMoney) * 0.6
            let secondPrize = Double(totalMoney) * 0.3
            let thirdPrize = Double(totalMoney) * 0.1
            self.firstPlacePrize = Int(firstPrize).roundedDown(toMultipleOf: 5)
            self.secondPlacePrize = Int(secondPrize).roundedDown(toMultipleOf: 5)
            self.thirdPlacePrize = Int(thirdPrize).roundedUp(toMultipleOf: 5)
        } else {
            let firstPrize = (Double(totalMoney) * 0.7)
            let secondPrize = (Double(totalMoney) * 0.3)
            // Always round up first prize cause winners gonna win!
            self.firstPlacePrize = Int(firstPrize).roundedUp(toMultipleOf: 5)
            // Check if rounded up value is larger than total money,
            // if yes round down
            // if no round up
            if self.firstPlacePrize + Int(secondPrize) > totalMoney {
                self.secondPlacePrize = Int(secondPrize).roundedDown(toMultipleOf: 5)
            } else {
                self.secondPlacePrize = Int(secondPrize).roundedUp(toMultipleOf: 5)
            }
            self.thirdPlacePrize = 0
        }
        self.highHandPrize = returnedPlayers.count * highHandBuyIn
    }
    
    
    func addPlayer() {
        players.append(Player())
    }
    
    func removePlayer() {
        players.removeFirst()
    }
}