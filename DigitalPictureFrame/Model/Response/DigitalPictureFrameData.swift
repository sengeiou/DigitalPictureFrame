//
//  DigitalPictureFrameData.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

struct DigitalPictureFrameData: Codable {
  enum Keys: String {
    case UDID
    case users
    case settings
    case wifiInfo
  }
  
  var UDID: String?
  var users: [User]?
  var settings: Settings?
  var wifiInfo: WiFiInfo?
  
  
  init() {
    self.UDID = nil
    self.users = nil
    self.settings = nil
    self.wifiInfo = nil
  }
  
  init(UDID: String, users: [User], settings: Settings, wifiInfo: WiFiInfo) {
    self.UDID = UDID
    self.users = users
    self.settings = settings
    self.wifiInfo = wifiInfo
  }
}
