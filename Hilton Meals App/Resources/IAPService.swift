//
//  IAPService.swift
//  Hilton Meals App
//
//  Created by Robert Haynes on 2019/05/23.
//  Copyright © 2019 Haynes Developments. All rights reserved.
//

import Foundation
import StoreKit

class IAPService : NSObject {
    
    private override init() {}
    static let shared = IAPService()
    
    var products = [SKProduct]()
    var price = ""
    let paymentQueue = SKPaymentQueue.default()
    
    func getProducts() {
        let products : Set = [IAPProduct.removeAds.rawValue]
        
        let request = SKProductsRequest(productIdentifiers: products)
        request.delegate = self
        request.start()
        paymentQueue.add(self)
    }
    
    func purchase(product : IAPProduct) {
        guard let productToPurchase = products.filter({ $0.productIdentifier == product.rawValue }).first else { return }
        let payment = SKPayment(product: productToPurchase)
        paymentQueue.add(payment)
    }
    
    func restorePurchases() {
        paymentQueue.restoreCompletedTransactions()
    }
    
}

extension IAPService: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        self.products = response.products
        
        for product in response.products {
            print(product.localizedTitle)
            let numberFormatter = NumberFormatter()
            numberFormatter.formatterBehavior = .behavior10_4
            numberFormatter.numberStyle = .currency
            numberFormatter.locale = product.priceLocale
            let priceStr = numberFormatter.string(from: product.price)
            price = priceStr ?? "No Price Availible"
            print(priceStr!)
        }
    }
}

extension IAPService : SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            print(transaction.transactionState.status(), transaction.payment.productIdentifier)
            switch transaction.transactionState {
            case .purchasing : break
            default: queue.finishTransaction(transaction)
            }
        }
    }
}

extension SKPaymentTransactionState {
    func status() -> String {
        switch self {
        case .deferred: return "Deferred"
        case .failed: return "Failed"
        case .purchased:
            UserDefaults.standard.set(true, forKey: "hasRemovedAds")
            return "Purchase"
            
        case .purchasing: return "Purchasing"
        case .restored: return "Restored"
        
        @unknown default:
            return "New State"
        }
    }
}
