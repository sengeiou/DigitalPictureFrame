//
//  CharacteristicPropertyType.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import CoreBluetooth

enum CharacteristicPropertyType {
  case broadcast
  case read
  case writeWithoutResponse
  case write
  case notify
  case indicate
  case authenticatedSignedWrites
  case extendedProperties
  case notifyEncryptionRequired
  case indicateEncryptionRequired
}


// MARK: - RawValue
extension CharacteristicPropertyType {
  
  var rawValue: UInt {
    switch self {
    case .broadcast:
      return CBCharacteristicProperties.broadcast.rawValue
      
    case .read:
      return CBCharacteristicProperties.read.rawValue
      
    case .writeWithoutResponse:
      return CBCharacteristicProperties.writeWithoutResponse.rawValue
      
    case .write:
      return CBCharacteristicProperties.write.rawValue
      
    case .notify:
      return CBCharacteristicProperties.notify.rawValue
      
    case .indicate:
      return CBCharacteristicProperties.indicate.rawValue
      
    case .authenticatedSignedWrites:
      return CBCharacteristicProperties.authenticatedSignedWrites.rawValue
      
    case .extendedProperties:
      return CBCharacteristicProperties.extendedProperties.rawValue
      
    case .notifyEncryptionRequired:
      return CBCharacteristicProperties.notifyEncryptionRequired.rawValue
      
    case .indicateEncryptionRequired:
      return CBCharacteristicProperties.indicateEncryptionRequired.rawValue
    }
  }
  
}


// MARK: - CustomStringConvertible protocol
extension CharacteristicPropertyType: CustomStringConvertible {
  
  var description: String {
    switch self {
    case .broadcast:
      return "Broadcast"
      
    case .read:
      return "Read"
      
    case .writeWithoutResponse:
      return "Write Without Response"
      
    case .write:
      return "Write"
      
    case .notify:
      return "Notify"
      
    case .indicate:
      return "Indicate"
      
    case .authenticatedSignedWrites:
      return "Authenticated Signed Writes"
      
    case .extendedProperties:
      return "Extended Properties"
      
    case .notifyEncryptionRequired:
      return "Notify Encryption Required"
      
    case .indicateEncryptionRequired:
      return "Indicate Encryption Required"
    }
  }
  
}
