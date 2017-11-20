//
//  NotificationName.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

enum NotificationName: String {
  case showNoDataAvailableMessage = "ShowNoDataAvailableMessage"
  case showAlertViewMessageToEnterNewWirelessNetworkPassword = "ShowAlertViewMessageToEnterNewWirelessNetworkPassword"
  case showAlertViewMessageNoWirelessNetworkConnected = "ShowAlertViewNoWirelessNetworkConnected"
  case reloadData = "ReloadData"
  case refreshData = "RefreshData"
  case endRefreshingIndicator = "EndRefreshingIndicator"
  case tabBarItemSelectedAtIndex = "TabBarItemSelectedAtIndex"
  
  var name: Notification.Name {
    return Notification.Name(self.rawValue)
  }
}

