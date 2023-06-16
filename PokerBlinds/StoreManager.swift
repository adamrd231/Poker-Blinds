//
//  StoreManager.swift
//  adamsCalc
//
//  Created by Adam Reed on 6/29/21.
//

import Foundation
import StoreKit

class StoreManager: NSObject, Identifiable, ObservableObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    @Published var myProducts = [SKProduct]()
    var request: SKProductsRequest!
    @Published var transactionState: SKPaymentTransactionState?
    @Published var purchasedRemoveAds = UserDefaults.standard.bool(forKey: "purchasedRemoveAds") {
        didSet {
            UserDefaults.standard.setValue(self.purchasedRemoveAds, forKey: "purchasedRemoveAds")
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {

        if !response.products.isEmpty {
            for fetchedProduct in response.products {
                DispatchQueue.main.async {
                    self.myProducts.append(fetchedProduct)
                }
            }
        }
        
        for invalidIdentifier in response.invalidProductIdentifiers {
            print("Invalid identifiers found: \(invalidIdentifier)")
        }
    }
    
    func getProducts(productIDs: [String]) {
        print("Start requesting products ...")
        let request = SKProductsRequest(productIdentifiers: Set(productIDs))
        request.delegate = self
        request.start()
    }

    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                transactionState = .purchasing
            case .purchased:
                UserDefaults.standard.setValue(true, forKey: transaction.payment.productIdentifier)
                queue.finishTransaction(transaction)
                purchasedRemoveAds = true
                transactionState = .purchased
            case .restored:
                print("Restored")
                UserDefaults.standard.setValue(true, forKey: transaction.payment.productIdentifier)
                queue.finishTransaction(transaction)
                purchasedRemoveAds = true
                transactionState = .restored
            case .failed, .deferred:
                print("Payment Queue Error: \(String(describing: transaction.error))")
                    queue.finishTransaction(transaction)
                    transactionState = .failed
                    purchasedRemoveAds = false
                    default:
                    queue.finishTransaction(transaction)
            }
        }
    }
    
    func purchaseProduct(product: SKProduct) {
        
        if SKPaymentQueue.canMakePayments() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
            print("purchasing product")
        } else {
            print("User can't make payment.")
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Request did fail: \(error)")
    }
    
    func restoreProducts() {
        print("Restoring products ...")
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}
