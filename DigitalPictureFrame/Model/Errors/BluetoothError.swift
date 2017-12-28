//
//  BluetoothError.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

enum BluetoothError: Error {
  case peripheralNotReady
  case peripheralNoServicesAvailable
  case peripheralNoCharacteristicAvailable
  case encodedDataForArduinoNotAvailable
  case unsupportedError
}


// MARK: - Localized description
extension BluetoothError: CustomStringConvertible {
  
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


// MARK: - Handle errors
extension BluetoothError {
  
  static func handle(error: BluetoothError = .unsupportedError) {
    AlertViewPresenter.sharedInstance.presentErrorAlert(withMessage: error.description)
  }
  
}
