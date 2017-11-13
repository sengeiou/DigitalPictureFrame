//
//  DigitalPictureFrameDataError.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

enum DigitalPictureFrameDataError: Error {
  case invalidUserCredentials
  case unrecognizedWirelessNetwork
}


// MARK: - Localized description
extension DigitalPictureFrameDataError: CustomStringConvertible {
  
  var description: String {
    switch self {
    case .invalidUserCredentials:
      return "Invalid User Credential"
      
    case .unrecognizedWirelessNetwork:
      return "Unrecognized Wireless Network"
    }
  }
  
}
