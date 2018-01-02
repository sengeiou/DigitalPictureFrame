//
//  Cryptor.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import RNCryptor

final class Cryptor {
  static let shared = Cryptor()
  
  private var encryptionKey: String {
    return KeychainService.shared["key"]!
  }
  
  
  private init() {
    KeychainService.shared.loggingEnabled = true
    KeychainService.shared["key"] = "MySecretPassword"
  }
}


// MARK: - Encryption
extension Cryptor {
  
  func encrypt(password: String) -> Data {
    let data = password.data(using: .utf8)
    let cipherText = RNCryptor.encrypt(data: data!, withPassword: encryptionKey)
    return cipherText
  }
  
}


// MARK: - Decryption
extension Cryptor {
  
  func decrypt(password: Data) -> String? {
    var decryptString: String?
    
    do {
      let decryptData = try RNCryptor.decrypt(data: password, withPassword: encryptionKey)
      decryptString = String(data: decryptData, encoding: .utf8)
      
    } catch {
      CryptError.handle(error: .decryptionFaild)
    }
    
    return decryptString
  }
  
}


// MARK: - Convert into Base64/Data
extension Cryptor {
  
  func convertIntoDataEncrypted(base64 string: String) -> Data? {
    let data = Data(base64Encoded: string, options: .ignoreUnknownCharacters)
    return data
  }
  
  
  func convertIntoBase64Encrypted(data: Data) -> String {
    let base64 = data.base64EncodedString(options: [])
    return base64
  }
  
  
  
}
