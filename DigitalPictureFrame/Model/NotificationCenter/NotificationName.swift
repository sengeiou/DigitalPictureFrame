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
  case verifyConnectedNetwork = "VerifyConnectedNetwork"
  case endRefreshingIndicator = "EndRefreshingIndicator"
  case tabBarItemSelectedAtIndex = "TabBarItemSelectedAtIndex"
  case reloadData = "ReloadData"
  case refreshData = "RefreshData"
  
  case peripheralDisconnectNotification = "PeripheralDisconnectNotification"
  case peripheralCharacteristicDiscoverNotification = "PeripheralCharacteristicDiscoverNotification"
  
  var name: Notification.Name {
    return Notification.Name(self.rawValue)
  }
}
