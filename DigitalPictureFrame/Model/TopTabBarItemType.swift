//
//  TopTabBarItemType.swift
//  Digital Picture Frame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit

enum TopTabBarItemType: Int, CustomStringConvertible {
  case users = 1
  case settings = 2
  case wifi = 3
  case bluetoothConnectivity = 4
}


// MARK: CustomStringConvertible protocol
extension TopTabBarItemType {
  
  var description: String {
    switch self {
    case .users:
      return "Users"
      
    case .settings:
      return "Settings"
      
    case .wifi:
      return "WiFi"
      
    case .bluetoothConnectivity:
      return "Bluetooth"
    }
  }
  
}


// MARK: Icon
extension TopTabBarItemType {
  
  var icon: UIImage {
    switch self {
    case .users:
      return UIImage(named: "icon-users")!
      
    case .settings:
      return UIImage(named: "icon-settings")!
      
    case .wifi:
      return UIImage(named: "icon-wifi")!
      
    case .bluetoothConnectivity:
      return UIImage(named: "icon-bluetooth")!
    }
  }
  
}
