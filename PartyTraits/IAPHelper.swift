//
//  IAPHelper.swift
//  PartyTraits
//
//  Created by Jared Stevens2 on 12/1/16.
//  Copyright © 2016 Jared Stevens. All rights reserved.
//

import Foundation
import StoreKit

public typealias ProductIdentifier = String
public typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> ()

open class IAPHelper : NSObject  {
    
    static let IAPHelperPurchaseNotification = "IAPHelperPurchaseNotification"
    
    public init(productIds: Set<ProductIdentifier>) {
        super.init()
    }
}

// MARK: - StoreKit API

extension IAPHelper {
    
    public func requestProducts(_ completionHandler: ProductsRequestCompletionHandler) {
        completionHandler(false, [])
    }
    
    public func buyProduct(_ product: SKProduct) {
    }
    
    public func isProductPurchased(_ productIdentifier: ProductIdentifier) -> Bool {
        return false
    }
    
    public class func canMakePayments() -> Bool {
        return true
    }
    
    public func restorePurchases() {
    }
}


import Foundation

public struct PartyTraitsProducts {
    
    public static let GirlfriendOfDrummerRage = "CreateTraits"
    
    fileprivate static let productIdentifiers: Set<ProductIdentifier> = [PartyTraitsProducts.GirlfriendOfDrummerRage]
    
    public static let store = IAPHelper(productIds: PartyTraitsProducts.productIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}
