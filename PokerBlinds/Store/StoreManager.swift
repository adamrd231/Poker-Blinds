//
//  StoreManager.swift
//  adamsCalc
//
//  Created by Adam Reed on 6/29/21.
//

import Foundation
//import SwiftUI
import StoreKit
import Combine

class StoreManager: ObservableObject  {
    
    @Published var products:[Product] = []
    @Published var purchasedNonConsumables: Set<Product> = []
    @Published var roundWarningUnlocked: Bool = false
    @Published var removedAdvertising: Bool?
//    @Published var purchasedNonConsumables = [Product]()
    var productIds = ["removePokerAdvertising", "roundWarningFeature"]
    
    // Listen for transactions that might be successful but not recorded
    var transactionListener: Task <Void, Error>?
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        transactionListener = listenForTransactions()
        Task {
            await requestProducts()
            // Must be called after products have already been fetched
            // Transactions do not contain product or product info
            await updateCurrentEntitlements()
            await updatePurchases()
        }
    }
    
    @MainActor
    func updatePurchases() {
        print("Updating purchases ------------")
        if purchasedNonConsumables.contains(where: { $0.id == "removePokerAdvertising"}) {
            print("Removed advertising true")
            self.removedAdvertising = true
        }
        if purchasedNonConsumables.contains(where: { $0.id == "roundWarningFeature"}) {
            print("unlock feature true")
            self.roundWarningUnlocked = true
        }
    }
    
    @MainActor
    func requestProducts() async {
        do {
            products = try await Product.products(for: productIds)
        } catch let error {
            print("Error requesting products: \(error)")
        }
    }
    
    @MainActor
    func purchase(_ product: Product) async throws -> Transaction? {
        let result = try await product.purchase()
        switch result {
        case .success(.verified(let transaction)):
            purchasedNonConsumables.insert(product)
            await transaction.finish()
            return transaction
            
        default: return nil
        }
    }
    
    func listenForTransactions() -> Task <Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                await self.handle(transactionVerification: result)
            }
        }
    }
    

    private func updateCurrentEntitlements() async {
        for await result in Transaction.currentEntitlements {
            await self.handle(transactionVerification: result)
        }
    }
    
    @MainActor
    func restorePurchases() async throws {
        try await AppStore.sync()
        print("transactions \(purchasedNonConsumables.count)")
    }

    @MainActor
    private func handle(transactionVerification result: VerificationResult <Transaction> ) async {
        switch result {
            case let.verified(transaction):
                guard let product = self.products.first(where: { $0.id == transaction.productID }) else { return }
                self.purchasedNonConsumables.insert(product)
                print(self.purchasedNonConsumables.count)
                await transaction.finish()
            default: return
        }
    }
}
