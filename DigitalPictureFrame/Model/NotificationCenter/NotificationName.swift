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
  case reloadData = "ReloadData"
  case refreshData = "RefreshData"
  
  var name: Notification.Name {
    return Notification.Name(self.rawValue)
  }
}

