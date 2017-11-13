//
//  TopTabBarItemType.swift
//  Digital Picture Frame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

enum TopTabBarItemType: Int, CustomStringConvertible {
  case users = 1
  case settings = 2
  case wifi = 3
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
    }
  }
  
}
