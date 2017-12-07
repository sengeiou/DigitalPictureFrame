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
    case phoneNumber
    case users
    case settings
    case wifiInfo
  }
  
  var phoneNumber: String?
  var users: [User]?
  var settings: Settings?
  var wifiInfo: WiFiInfo?
  
  
  init() {
    self.phoneNumber = nil
    self.users = nil
    self.settings = nil
    self.wifiInfo = nil
  }
  
  init(phoneNumber: String, users: [User], settings: Settings, wifiInfo: WiFiInfo) {
    self.phoneNumber = phoneNumber
    self.users = users
    self.settings = settings
    self.wifiInfo = wifiInfo
  }
}
