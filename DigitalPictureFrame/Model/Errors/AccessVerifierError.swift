//
//  AccessVerifierError.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

enum AccessVerifierError: ErrorHandleable {
  case accessDenied
  case dataNotAvailable(description: String)
  case invalidUserCredentials
  case unrecognizedWirelessNetwork
  case unsupportedError
}


// MARK: - ErrorHandleable protocol
extension AccessVerifierError {
  
  var description: String {
    switch self {
    case .accessDenied:
      return NSLocalizedString("DIGITAL_PICTURE_FRAME_PAGEVIEW_ALERT_VERIFY_INFO_MSG", comment: "")
      
    case .dataNotAvailable(let desc):
      let errorDesc = NSLocalizedString("DIGITAL_PICTURE_FRAME_PAGEVIEW_ALERT_VERIFY_FAILED_MSG", comment: "") + desc
      return errorDesc
      
    case .invalidUserCredentials:
      return "Invalid User Credential"
      
    case .unrecognizedWirelessNetwork:
      return "Unrecognized Wireless Network"
      
    case .unsupportedError:
      return "Unsupported Error"
    }
  }
  
}
