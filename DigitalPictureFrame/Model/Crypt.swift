//
//  Crypt.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import RNCryptor

final class Crypt {
  private let encryptionKey = "MySecretPassword"
}


// MARK: - Password encryption/decryption
extension Crypt {
  
  func encryptContentsToSecureData(for password: String) -> Data {
    let data = password.data(using: .utf8)
    let cipherText = RNCryptor.encrypt(data: data!, withPassword: encryptionKey)
    return cipherText
  }
  
  func decryptContents(of encryptData: Data) throws -> String? {
    var decryptString: String?
    
    do {
      let decryptData = try RNCryptor.decrypt(data: encryptData, withPassword: encryptionKey)
      decryptString = String(data: decryptData, encoding: .utf8)
    } catch {
      print(error)
    }
    
    return decryptString
  }
  
  
  func convertIntoBase64Encoded(data: Data) -> String {
    let base64 = data.base64EncodedString(options: [])
    return base64
  }
  
  func convertIntoData(string: String) -> Data? {
    let data = Data(base64Encoded: string, options: .ignoreUnknownCharacters)
    return data
  }
}
