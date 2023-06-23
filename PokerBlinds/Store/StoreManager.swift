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
//    @Published var purchasedNonConsumables = [Product]()
    private var removeAdvertising = "removePokerAdvertising"
    var productIds = ["removePokerAdvertising"]
    @Published var hasRemovedAdvertising: Bool?
    
    var purchasedRemoveAdvertising: Bool = false
    
    // Listen for transactions that might be successful but not recorded
    var transactionListener: Task <Void, Error>?
    private var cancellable = Set<AnyCancellable>()
    
    func checkIfRemovedAdvertising() -> Bool {
        let check = purchasedNonConsumables.contains(where: { $0.id == removeAdvertising})
        if check {
            return true
        } else {
            return false
        }
    }
    
    
    init() {
        transactionListener = listenForTransactions()
        Task {
            await requestProducts()
            // Must be called after products have already been fetched
            // Transactions do not contain product or product info
            await updateCurrentEntitlements()
            print("Removed? \(checkIfRemovedAdvertising())")
            hasRemovedAdvertising = checkIfRemovedAdvertising()
            print("home check \(String(describing: hasRemovedAdvertising))")
        }
    }
    
    func userPurchasedRemoveAdvertising(productID: String) -> Bool {
        print("purchase id \(purchasedNonConsumables)")
        if purchasedNonConsumables.contains(where: { $0.id.description == "removePokerAdvertising" }) {
            print("purchase true")
            return true
        } else {
            print("purchase false")
            return false
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
            print("result 99 \(result)")
            await self.handle(transactionVerification: result)
        }
    }

    @MainActor
    private func handle(transactionVerification result: VerificationResult <Transaction> ) async {
        switch result {
            case let.verified(transaction):
                print("Verified transaction")
                guard let product = self.products.first(where: { $0.id == transaction.productID }) else { return }
            print("verified and adding \(product)")
            print("non consumables \(self.purchasedNonConsumables)")
            print("non consu product \(product)")
                self.purchasedNonConsumables.insert(product)
            print("non consumables \(self.purchasedNonConsumables)")
                print("verified and appended")
                await transaction.finish()
            default: return
        }
    }
}
