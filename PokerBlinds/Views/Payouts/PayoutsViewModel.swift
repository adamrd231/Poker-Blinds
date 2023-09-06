//
//  PayoutsViewModel.swift
//  PokerBlinds
//
//  Created by Adam Reed on 9/6/23.
//

import Foundation
import Combine

struct Player: Identifiable {
    let id = UUID()
    var money: Double = 30
}

class PayoutsViewModel: ObservableObject {
    @Published var players: [Player] = [Player(), Player(), Player(), Player(), Player()]
    @Published var firstPlacePrize: Int = 0
    @Published var secondPlacePrize: Double = 0
    @Published var thirdPlacePrize: Double = 0
    @Published var highHandPrize: Double = 0
    
    private var highHandContribution:Double = 5
    // Cancellable for subscribers
    private var cancellable = Set<AnyCancellable>()
    
    func getTotalMoney() -> Double {
        return players.map({ $0.money }).reduce(0, +)
    }
    
    
    init() {
        subscribers()
    }
    
    func subscribers() {
        $players
            .sink { [weak self] (returnedPlayers) in
                print("ISSSS SINKING!")
                self?.distributeMoney()
            }
            .store(in: &cancellable)
        
        
    }
    
    
    // Returns money for first, second and if enough players, third place
    func distributeMoney() {
        
        let totalMoney = getTotalMoney()
        
        if self.players.count > 5 {
            self.firstPlacePrize = Int(totalMoney * 0.5)
        } else {
            self.firstPlacePrize = Int(totalMoney * 0.7)
        }
        
        self.highHandPrize = Double(players.count) * highHandContribution

    }
    
    func addPlayer() {
        players.append(Player())
    }
    
    func removePlayer() {
        players.removeLast()
    }
    
    
}
