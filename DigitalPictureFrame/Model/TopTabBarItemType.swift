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
      return NSLocalizedString("TABBAR_ITEM_USERS_TITLE", comment: "")
      
    case .settings:
      return NSLocalizedString("TABBAR_ITEM_SETTINGS_TITLE", comment: "")
      
    case .wifi:
      return NSLocalizedString("TABBAR_ITEM_WIFI_TITLE", comment: "")
      
    case .bluetoothConnectivity:
      return NSLocalizedString("TABBAR_ITEM_BLUETOOTH_TITLE", comment: "")
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
