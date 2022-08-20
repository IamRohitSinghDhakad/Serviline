//
//  ObjectIAPProducts.swift
//  Object Remover
//
//  Created by Anand on 21/09/21.
//

import Foundation

public struct ObjectIAPProducts {
  
  private static let productIdentifiers: Set<ProductIdentifier> = [AppSharedData.kProductMonthly]

  public static let store = ObjectIAPHelper(productIds: ObjectIAPProducts.productIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
  return productIdentifier.components(separatedBy: ".").last
}
