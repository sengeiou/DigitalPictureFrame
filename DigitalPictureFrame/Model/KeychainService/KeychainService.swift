//
//  KeychainService.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import Security

class KeychainService: NSObject {
  static private let passwordKey = "KeyForPassword"
  
  // Arguments for the keychain queries
  static private let kSecClassValue = KeychainQuerieType.classValue.rawValue
  static private let kSecAttrAccountValue = KeychainQuerieType.attrAccountValue.rawValue
  static private let kSecValueDataValue = KeychainQuerieType.valueDataValue.rawValue
  static private let kSecClassGenericPasswordValue = KeychainQuerieType.classGenericPasswordValue.rawValue
  static private let kSecAttrServiceValue = KeychainQuerieType.attrServiceValue.rawValue
  static private let kSecMatchLimitValue = KeychainQuerieType.matchLimitValue.rawValue
  static private let kSecReturnDataValue = KeychainQuerieType.returnDataValue.rawValue
  static private let kSecMatchLimitOneValue = KeychainQuerieType.matchLimitOneValue.rawValue
  
  /**
   *  User defined keys for new entry
   *  Note: Add new keys for new secure item and use them in load and save methods
   */
  static private let userAccount = "AuthenticatedUser"
  static private let accessGroup = "SecuritySerivice"
  

  /**
   * Exposed methods to perform save and load queries.
   */
  public class func save(token: NSString) {
    self.save(service: passwordKey as NSString, data: token)
  }
  
  public class func load() -> NSString? {
    return self.load(service: passwordKey as NSString)
  }
  
  
  /**
   * Internal methods for querying the keychain.
   */
  private class func save(service: NSString, data: NSString) {
    let dataFromString: NSData = data.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)! as NSData
    
    // Instantiate a new default keychain query
    let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, userAccount, dataFromString], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecValueDataValue])
    
    // Delete any existing items
    SecItemDelete(keychainQuery as CFDictionary)
    
    // Add the new keychain item
    SecItemAdd(keychainQuery as CFDictionary, nil)
  }

  private class func load(service: NSString) -> NSString? {
    // Instantiate a new default keychain query
    // Tell the query to return a result
    // Limit our results to one item
    let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, userAccount, kCFBooleanTrue, kSecMatchLimitOneValue], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])
    
    var dataTypeRef: AnyObject?
    
    // Search for the keychain items
    let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)
    var contentsOfKeychain: NSString? = nil
    
    if status == errSecSuccess {
      if let retrievedData = dataTypeRef as? NSData {
        contentsOfKeychain = NSString(data: retrievedData as Data, encoding: String.Encoding.utf8.rawValue)
      }
    } else {
      print("Nothing was retrieved from the keychain. Status code \(status)")
    }
    
    return contentsOfKeychain
  }
}

