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
  static let shared = KeychainService()
  
  var loggingEnabled = false
  
  private override init() {
    super.init()
  }
  
  
  open subscript(key: String) -> String? {
    get {
      return load(withKey: key)
    } set {
      DispatchQueue.global().sync(flags: .barrier) {
        self.save(newValue, forKey: key)
      }
    }
  }
  

  private func logPrint(_ items: Any...) {
    if loggingEnabled {
      print(items)
    }
  }
}


// MARK: - Save/Load
private extension KeychainService {
  
  func save(_ string: String?, forKey key: String) {
    let query = keychainQuery(withKey: key)
    let objectData = string?.data(using: .utf8, allowLossyConversion: false)
    
    if SecItemCopyMatching(query, nil) == noErr {
      if let dictData = objectData {
        let status = SecItemUpdate(query, NSDictionary(dictionary: [kSecValueData: dictData]))
        logPrint("Update status: ", status)
        
      } else {
        let status = SecItemDelete(query)
        logPrint("Delete status: ", status)
      }
      
    } else if let dictData = objectData {
      query.setValue(dictData, forKey: kSecValueData as String)
      let status = SecItemAdd(query, nil)
      logPrint("Update status: ", status)
    }
  }
  
  
  func load(withKey key: String) -> String? {
    let query = keychainQuery(withKey: key)
    query.setValue(kCFBooleanTrue, forKey: kSecReturnData as String)
    query.setValue(kCFBooleanTrue, forKey: kSecReturnAttributes as String)
    
    var result: CFTypeRef?
    let status = SecItemCopyMatching(query, &result)
    
    guard
      let resultsDict = result as? NSDictionary,
      let resultsData = resultsDict.value(forKey: kSecValueData as String) as? Data,
      status == noErr
      else {
        logPrint("Load status: ", status)
        return nil
    }
    return String(data: resultsData, encoding: .utf8)
  }
  
  
  func keychainQuery(withKey key: String) -> NSMutableDictionary {
    let result = NSMutableDictionary()
    result.setValue(kSecClassGenericPassword, forKey: kSecClass as String)
    result.setValue(key, forKey: kSecAttrService as String)
    result.setValue(kSecAttrAccessibleAlwaysThisDeviceOnly, forKey: kSecAttrAccessible as String)
    return result
  }
  
}
