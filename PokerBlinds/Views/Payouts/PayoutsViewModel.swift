//
//  PayoutsViewModel.swift
//  PokerBlinds
//
//  Created by Adam Reed on 9/6/23.
//

import Foundation
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
    var money: Double = 30
    var startingChips: Int = 10_000
}

class PayoutsViewModel: ObservableObject {
    @Published var players: [Player] = [Player(), Player(), Player(), Player(), Player()]
    @Published var firstPlacePrize: Int = 0
    @Published var secondPlacePrize: Int = 0
    @Published var thirdPlacePrize: Int = 0
    @Published var highHandPrize: Int = 0
    @Published var startingStack: Int = 10_000
    
    private var highHandContribution:Int = 5
    // Cancellable for subscribers
    private var cancellable = Set<AnyCancellable>()
    
    func getTotalPrizeMoney() -> Int {
        let totalMoney = Int(players.map({ $0.money }).reduce(0, +))
        let totalHighHandContribution = players.count * highHandContribution
        return totalMoney - totalHighHandContribution
    }
    
    func getTotalMoney() -> Int {
        return Int(players.map({ $0.money }).reduce(0, +))
    }
    
    
    init() {
        subscribers()
    }
    
    func subscribers() {
        $players
            .sink { [weak self] (returnedPlayers) in
                self?.distributeMoney(playerCount: returnedPlayers.count, returnedPlayers: returnedPlayers)
            }
            .store(in: &cancellable)
        
        
    }
    
    
    // Returns money for first, second and if enough players, third place
    func distributeMoney(playerCount: Int, returnedPlayers: [Player]) {
        
        let totalMoney = Int(returnedPlayers.map({ $0.money }).reduce(0, +)) - (returnedPlayers.count * highHandContribution)
        print("Total money \(totalMoney)")
        
        if playerCount > 6 {
            let firstPrize = Double(totalMoney) * 0.6
            let secondPrize = Double(totalMoney) * 0.3
            let thirdPrize = Double(totalMoney) * 0.1
            print("first \(firstPrize)")
            print("second \(secondPrize)")
            print("third \(thirdPrize)")
   
            self.firstPlacePrize = Int(firstPrize).roundedDown(toMultipleOf: 5)

            self.secondPlacePrize = Int(secondPrize).roundedDown(toMultipleOf: 5)
            

            self.thirdPlacePrize = Int(thirdPrize).roundedUp(toMultipleOf: 5)
        } else {
         
            let firstPrize = (Double(totalMoney) * 0.7)
            let secondPrize = (Double(totalMoney) * 0.3)
            print("first \(firstPrize)")
            print("second \(secondPrize)")
     
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
        print("High hand \(players.count) and \(highHandContribution)")
        self.highHandPrize = playerCount * highHandContribution

    }
    
    
    func addPlayer() {
        players.append(Player())
    }
    
    func removePlayer() {
        players.removeFirst()
    }
    
    
}
