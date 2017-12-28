//
//  AccessVerifierError.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

enum AccessVerifierError: Error {
  case accessDenied
  case dataNotAvailable(description: String)
  case invalidUserCredentials
  case unrecognizedWirelessNetwork
}


// MARK: - Localized description
extension AccessVerifierError: CustomStringConvertible {
  
  var description: String {
    switch self {
    case .accessDenied:
      return "Access Denied"
      
    case .dataNotAvailable(_):
      return "Data Not Available"
      
    case .invalidUserCredentials:
      return "Invalid User Credential"
      
    case .unrecognizedWirelessNetwork:
      return "Unrecognized Wireless Network"
    }
  }
  
}
