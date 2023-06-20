//
//  StoreManager.swift
//  adamsCalc
//
//  Created by Adam Reed on 6/29/21.
//

import Foundation
import StoreKit

class StoreManager: ObservableObject  {
    
    @Published var products = [Product]()
    @Published var purchasedNonConsumables = Set<Product>()
    var productIds = ["removePokerAdvertising"]
    
    // Listen for transactions that might be successful but not recorded
    var transactionListener: Task <Void, Error>?
    
    init() {
        transactionListener = listenForTransactions()
        Task {
            await requestProducts()
        }
    }
    @MainActor
    func requestProducts() async {
        do {
            print("Request products async")
            products = try await Product.products(for: productIds)
            print("reeust products \(products)")
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
    
    @MainActor
    func handle(transactionVerification result: VerificationResult <Transaction> ) async {
        switch result {
            case let.verified(transaction):
                guard let product = self.products.first(where: { $0.id == transaction.productID }) else { return }
                self.purchasedNonConsumables.insert(product)
                await transaction.finish()
            default: return
        }
    }
    
    
//    @Published var myProducts = [SKProduct]()

//    var request: SKProductsRequest!
//    @Published var transactionState: SKPaymentTransactionState?
//

    
    // Keep record of user purchases
//    @Published var purchasedRemoveAds = UserDefaults.standard.bool(forKey: "purchasedRemoveAds") {
//        didSet {
//            UserDefaults.standard.setValue(self.purchasedRemoveAds, forKey: "purchasedRemoveAds")
//        }
//    }
//    var hasPurchasedAds: Bool {
//        checkForPurchases()
//    }
//
//
//    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
//
//        if !response.products.isEmpty {
//            for fetchedProduct in response.products {
//                DispatchQueue.main.async {
//                    self.myProducts.append(fetchedProduct)
//                }
//            }
//        }
//
//        for invalidIdentifier in response.invalidProductIdentifiers {
//            print("Invalid identifiers found: \(invalidIdentifier)")
//        }
//    }
//
//    func getProducts(productIDs: [String]) {
//        print("Start requesting products ...")
//        let request = SKProductsRequest(productIdentifiers: Set(productIDs))
//        request.delegate = self
//        request.start()
//    }
//
//
//    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
//        for transaction in transactions {
//            switch transaction.transactionState {
//            case .purchasing:
//                transactionState = .purchasing
//            case .purchased:
//                UserDefaults.standard.setValue(true, forKey: transaction.payment.productIdentifier)
//                queue.finishTransaction(transaction)
//                purchasedRemoveAds = true
//                transactionState = .purchased
//            case .restored:
//                print("Restored")
//                UserDefaults.standard.setValue(true, forKey: transaction.payment.productIdentifier)
//                queue.finishTransaction(transaction)
//                purchasedRemoveAds = true
//                transactionState = .restored
//            case .failed, .deferred:
//                print("Payment Queue Error: \(String(describing: transaction.error))")
//                    queue.finishTransaction(transaction)
//                    transactionState = .failed
//                    purchasedRemoveAds = false
//                    default:
//                    queue.finishTransaction(transaction)
//            }
//        }
//    }
//
//
//
//    func purchaseProduct(product: SKProduct) {
//
//        if SKPaymentQueue.canMakePayments() {
//            let payment = SKPayment(product: product)
//            SKPaymentQueue.default().add(payment)
//            print("purchasing product")
//        } else {
//            print("User can't make payment.")
//        }
//    }
//
//    func request(_ request: SKRequest, didFailWithError error: Error) {
//        print("Request did fail: \(error)")
//    }
//
//    func restoreProducts() {
//        print("Restoring products ...")
//        SKPaymentQueue.default().restoreCompletedTransactions()
//    }
//
//    func checkForPurchases() -> Bool {
//        let transactions = SKPaymentQueue.default().transactions
//        if transactions.count > 0 {
//            return true
//        } else {
//            return false
//        }
//    }
}
