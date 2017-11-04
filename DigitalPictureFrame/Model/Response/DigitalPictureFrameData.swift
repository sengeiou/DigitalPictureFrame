//
//  DigitalPictureFrameData.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/2/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

struct DigitalPictureFrameData: Codable {
  var phoneNumber: String
  var users: [User]
  var settings: Settings
  var wifiInfo: WiFiInfo
}
