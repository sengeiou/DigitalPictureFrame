//
//  KeychainQuerieType.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//

import Foundation

enum KeychainQuerieType {
  case classValue
  case attrAccountValue
  case valueDataValue
  case classGenericPasswordValue
  case attrServiceValue
  case matchLimitValue
  case returnDataValue
  case matchLimitOneValue
}


// MARK: - RawValue
extension KeychainQuerieType {
 
  var rawValue: NSString {
    switch self {
    case .classValue:
      return NSString(format: kSecClass)
      
    case .attrAccountValue:
      return NSString(format: kSecAttrAccount)
      
    case .valueDataValue:
      return NSString(format: kSecValueData)
      
    case .classGenericPasswordValue:
      return NSString(format: kSecClassGenericPassword)
      
    case .attrServiceValue:
      return NSString(format: kSecAttrService)
      
    case .matchLimitValue:
      return NSString(format: kSecMatchLimit)
      
    case .returnDataValue:
      return NSString(format: kSecReturnData)
      
    case .matchLimitOneValue:
      return NSString(format: kSecMatchLimitOne)
    }
  }
  
}
