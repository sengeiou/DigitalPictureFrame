//
//  CryptError.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

enum CryptError: ErrorHandleable {
  case decryptionFaild
}


// MARK: ErrorHandleable protocol
extension CryptError {
  
  var description: String {
    switch self {
    case .decryptionFaild:
      return "Password decryption faild"
    }
  }
  
}
