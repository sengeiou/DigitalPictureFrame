//
//  DigitalPictureFrameData.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/2/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

struct DigitalPictureFrameData: Codable {
  var UDID: String
  var users: [User]
  var settings: Settings
  var wifiInfo: WiFiInfo
  
  
  init() {
    self.UDID = ""
    self.users = []
    self.settings = Settings()
    self.wifiInfo = WiFiInfo()
  }
  
  init(UDID: String, users: [User], settings: Settings, wifiInfo: WiFiInfo) {
    self.UDID = UDID
    self.users = users
    self.settings = settings
    self.wifiInfo = wifiInfo
  }
}
