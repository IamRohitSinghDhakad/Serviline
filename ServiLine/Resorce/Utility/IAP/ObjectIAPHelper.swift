//
//  ObjectIAPHelper.swift
//  Object Remover
//
//  Created by Anand on 21/09/21.
//

import UIKit
import StoreKit

public typealias ProductIdentifier = String
public typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> Void

extension Notification.Name {
    static let IAPHelperPurchaseNotification = Notification.Name("IAPHelperPurchaseNotification")
    static let IAPPurchaseSuccess = Notification.Name("IAPPurchaseSuccess")
    static let IAPRestoreSuccess = Notification.Name("IAPRestoreSuccess")
    static let IAPPurchaseFailed = Notification.Name("IAPPurchaseFailed")
}

open class ObjectIAPHelper: NSObject {
    private let productIdentifiers: Set<ProductIdentifier>
    private var purchasedProductIdentifiers: Set<ProductIdentifier> = []
    private var productsRequest: SKProductsRequest?
    private var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
    
    public init(productIds: Set<ProductIdentifier>) {
        productIdentifiers = productIds
        for productIdentifier in productIds {
            let purchased = UserDefaults.standard.bool(forKey: productIdentifier)
            if purchased {
                purchasedProductIdentifiers.insert(productIdentifier)
                print("Previously purchased: \(productIdentifier)")
            } else {
                print("Not purchased: \(productIdentifier)")
            }
        }
        
        super.init()
        SKPaymentQueue.default().add(self)
    }
}

// MARK: - StoreKit API

extension ObjectIAPHelper {
    
    public func requestProducts(_ completionHandler: @escaping ProductsRequestCompletionHandler) {
        productsRequest?.cancel()
        productsRequestCompletionHandler = completionHandler
        
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest!.delegate = self
        productsRequest!.start()
    }
    
    public func buyProduct(_ product: SKProduct) {
        print("Buying \(product.productIdentifier)...")
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    public func isProductPurchased(_ productIdentifier: ProductIdentifier) -> Bool {
        return purchasedProductIdentifiers.contains(productIdentifier)
    }
    
    public class func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    public func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

// MARK: - SKProductsRequestDelegate

extension ObjectIAPHelper: SKProductsRequestDelegate {
    
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        print("Loaded list of products...")
        let products = response.products
        productsRequestCompletionHandler?(true, products)
        clearRequestAndHandler()
        
        for p in products {
            print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
        }
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to load list of products.")
        print("Error: \(error.localizedDescription)")
        productsRequestCompletionHandler?(false, nil)
        clearRequestAndHandler()
    }
    
    private func clearRequestAndHandler() {
        productsRequest = nil
        productsRequestCompletionHandler = nil
    }
}

// MARK: - SKPaymentTransactionObserver

extension ObjectIAPHelper: SKPaymentTransactionObserver {
    
    public func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        ActivityIndicatorViewController.sharedInstance.stopIndicator()
        if queue.transactions.count > 0 {
            for transaction in queue.transactions {
                complete(transaction: transaction )
            }
        } else {
            print("IAP: No purchases to restore!")
//            ApplicationManager.sharedInstance.showAlert(title: "", message: "No purchases to restore!", actionTitle: "Ok")
        }
        
    }
    
    public func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        ActivityIndicatorViewController.sharedInstance.stopIndicator()
        
        if let error = error as? SKError {
            for transaction in queue.transactions {
                if error.code != .paymentCancelled {
                    print("IAP Restore Error:", error.localizedDescription)
                    fail(transaction: transaction)
                } else {
                    fail(transaction: transaction)
                }
            }
        }
    }
    
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch (transaction.transactionState) {
            case .purchased:
                print("purchased")
                complete(transaction: transaction)
                break
            case .failed:
                print("failed")
                ActivityIndicatorViewController.sharedInstance.stopIndicator()
                fail(transaction: transaction)
                break
            case .restored:
                restore(transaction: transaction)
                break
            case .deferred:
                print("deffered")
                break
            case .purchasing:
                //         ApplicationManager.sharedInstance.showActivityIndicator(Enable: false)
                print("purchasing")
                break
            @unknown default:
                break
            }
        }
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        print("complete...")
        ActivityIndicatorViewController.sharedInstance.stopIndicator()
        objAppShareData.isItemPurchased = true
      //  objAppShareData.call_updateMembership()
//        deliverPurchaseSuccessNotificationFor(identifier: transaction.payment.productIdentifier)
        deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func restore(transaction: SKPaymentTransaction) {
        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
        print("restore... \(productIdentifier)")
        ActivityIndicatorViewController.sharedInstance.stopIndicator()
        objAppShareData.isItemPurchased = (productIdentifier == "") ? false : true
        UserDefaults.standard.set((productIdentifier == "") ? false : true, forKey: productIdentifier)
        UserDefaults.standard.set(productIdentifier, forKey: AppSharedData.kPurchasedProductId)
        objAppShareData.call_updateMembership()
//        deliverRestoreSuccessNotificationFor(identifier: productIdentifier)
        deliverPurchaseNotificationFor(identifier: productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func fail(transaction: SKPaymentTransaction) {
        print("fail...")
        ActivityIndicatorViewController.sharedInstance.stopIndicator()
        if let transactionError = transaction.error as NSError?,
            let localizedDescription = transaction.error?.localizedDescription,
            transactionError.code != SKError.paymentCancelled.rawValue {
            print("Transaction Error: \(localizedDescription)")
//            deliverPurchaseFailNotificationFor(errorDesc: localizedDescription)
        }
        
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    //MARK: - Post IAP Purchase Status Notification
    
    private func deliverPurchaseSuccessNotificationFor(identifier: String?) {
        guard let identifier = identifier else { return }
//        purchasedProductIdentifiers.insert(identifier)
        NotificationCenter.default.post(name: .IAPPurchaseSuccess, object: identifier)
    }
    
    private func deliverPurchaseFailNotificationFor(errorDesc: String?) {
        guard let error = errorDesc else { return }
//        purchasedProductIdentifiers.insert(identifier)
        NotificationCenter.default.post(name: .IAPPurchaseFailed, object: error)
    }
    
    private func deliverRestoreSuccessNotificationFor(identifier: String?) {
        guard let identifier = identifier else { return }
//        purchasedProductIdentifiers.insert(identifier)
        NotificationCenter.default.post(name: .IAPRestoreSuccess, object: identifier)
    }
    
    private func deliverPurchaseNotificationFor(identifier: String?) {
        guard let identifier = identifier else { return }
        purchasedProductIdentifiers.insert(identifier)
        UserDefaults.standard.set(true, forKey: identifier)
        UserDefaults.standard.set(identifier, forKey: AppSharedData.kPurchasedProductId)
        NotificationCenter.default.post(name: .IAPHelperPurchaseNotification, object: identifier)
    }
    
}

