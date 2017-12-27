////
////  KeychainService.swift
////  DigitalPictureFrame
////
////  Created by Pawel Milek.
////  Copyright © 2017 Pawel Milek. All rights reserved.
////
//
//import Foundation
//import Security
//
//
//
//enum keychainQuerieType {
//  case kSecClassValue = NSString(format: kSecClass)
//  case kSecAttrAccountValue = NSString(format: kSecAttrAccount)
//  case kSecValueDataValue = NSString(format: kSecValueData)
//  case kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)
//  case kSecAttrServiceValue = NSString(format: kSecAttrService)
//  case kSecMatchLimitValue = NSString(format: kSecMatchLimit)
//  case kSecReturnDataValue = NSString(format: kSecReturnData)
//  case kSecMatchLimitOneValue = NSString(format: kSecMatchLimitOne)
//  
//  
//  var rawValue: NSString {
//    switch self {
//    case .kSecClassValue: return NSString(format: kSecClass)
//    case .kSecAttrAccountValue: return NSString(format: kSecAttrAccount)
//    case .kSecValueDataValue: return NSString(format: kSecValueData)
//    case .kSecClassGenericPasswordValue: return NSString(format: kSecClassGenericPassword)
//    case .kSecAttrServiceValue: return NSString(format: kSecAttrService)
//    case .kSecMatchLimitValue: return NSString(format: kSecMatchLimit)
//    case .kSecReturnDataValue: return NSString(format: kSecReturnData)
//    case .kSecMatchLimitOneValue: return NSString(format: kSecMatchLimitOne)
//    }
//  }
//}
//
//
//class KeychainService: NSObject {
//  let userAccount = "AuthenticatedUser"
//  let accessGroup = "SecuritySerivice"
//  /**
//   *  User defined keys for new entry
//   *  Note: add new keys for new secure item and use them in load and save methods
//   */
//  
//  static private let passwordKey = "KeyForPassword"
//  
//  // Arguments for the keychain queries
//  static private let kSecClassValue = NSString(format: kSecClass)
//  static private let kSecAttrAccountValue = NSString(format: kSecAttrAccount)
//  static private let kSecValueDataValue = NSString(format: kSecValueData)
//  static private let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)
//  static private let kSecAttrServiceValue = NSString(format: kSecAttrService)
//  static private let kSecMatchLimitValue = NSString(format: kSecMatchLimit)
//  static private let kSecReturnDataValue = NSString(format: kSecReturnData)
//  static private let kSecMatchLimitOneValue = NSString(format: kSecMatchLimitOne)
//  
//  /**
//   * Exposed methods to perform save and load queries.
//   */
//  
//  public class func savePassword(token: NSString) {
//    self.save(service: passwordKey as NSString, data: token)
//  }
//  
//  public class func loadPassword() -> NSString? {
//    return self.load(service: passwordKey as NSString as NSString)
//  }
//  
//  /**
//   * Internal methods for querying the keychain.
//   */
//  
//  private class func save(service: NSString, data: NSString) {
//    let dataFromString: NSData = data.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)! as NSData
//    
//    // Instantiate a new default keychain query
//    let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, userAccount, dataFromString], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecValueDataValue])
//    
//    // Delete any existing items
//    SecItemDelete(keychainQuery as CFDictionary)
//    
//    // Add the new keychain item
//    SecItemAdd(keychainQuery as CFDictionary, nil)
//  }
//  
//  private class func load(service: NSString) -> NSString? {
//    // Instantiate a new default keychain query
//    // Tell the query to return a result
//    // Limit our results to one item
//    let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, userAccount, kCFBooleanTrue, kSecMatchLimitOneValue], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])
//    
//    var dataTypeRef :AnyObject?
//    
//    // Search for the keychain items
//    let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)
//    var contentsOfKeychain: NSString? = nil
//    
//    if status == errSecSuccess {
//      if let retrievedData = dataTypeRef as? NSData {
//        contentsOfKeychain = NSString(data: retrievedData as Data, encoding: String.Encoding.utf8.rawValue)
//      }
//    } else {
//      print("Nothing was retrieved from the keychain. Status code \(status)")
//    }
//    
//    return contentsOfKeychain
//  }
//}

