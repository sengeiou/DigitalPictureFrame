//
//  NetworkConnectionUtility.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import SystemConfiguration.CaptiveNetwork

final class NetworkConnectionUtility {
  // Return "" if no connected wifi or running in simulator
  static func fetchSSIDInfo() -> String? {
    var currentSSID: String?
    
    if let interfaces:CFArray = CNCopySupportedInterfaces() {
      for i in 0..<CFArrayGetCount(interfaces){
        let interfaceName: UnsafeRawPointer = CFArrayGetValueAtIndex(interfaces, i)
        let rec = unsafeBitCast(interfaceName, to: AnyObject.self)
        let unsafeInterfaceData = CNCopyCurrentNetworkInfo("\(rec)" as CFString)
        
        if let unsafeInterfaceData = unsafeInterfaceData, let interfaceData = unsafeInterfaceData as? [String: AnyObject] {
          currentSSID = interfaceData["SSID"] as? String
        }
      }
    }
    
    return currentSSID
  }
}
