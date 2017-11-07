//
//  NotificationName.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/6/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

enum NotificationName: String {
  case showTimePicker = "ShowTimePicker"
  case hideTimePicker = "hideTimePicker"

  case showZipcodeAlertView = "ShowZipcodeAlertView"
  case hideZipcodeAlertView = "HideZipcodeAlertView"
  
  var name: Notification.Name {
    return Notification.Name(self.rawValue)
  }
}

