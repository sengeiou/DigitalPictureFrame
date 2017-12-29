//
//  BluetoothError.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

enum BluetoothError: ErrorHandleable {
  case peripheralNotReady
  case peripheralNoServicesAvailable
  case peripheralNoCharacteristicAvailable
  case encodedDataForArduinoNotAvailable
  case unsupportedError
}


// MARK: - ErrorHandleable protocol
extension BluetoothError {
  
  var description: String {
    switch self {
    case .peripheralNotReady:
      return "Peripheral Not Ready"
      
    case .peripheralNoServicesAvailable:
      return "Peripheral No Services Available"
      
    case .peripheralNoCharacteristicAvailable:
      return "Peripheral No Characteristic Available"
      
    case .encodedDataForArduinoNotAvailable:
      return "Encoded Data For Arduino Not Available"
      
    case .unsupportedError:
      return "Unsupported Error"
    }
  }
  
}
