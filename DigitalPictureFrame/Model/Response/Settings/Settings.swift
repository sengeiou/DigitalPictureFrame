//
//  Settings.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

final class Settings: GeneralSettingsSection, TimeSettingsSection, ZipCodeSettingsSection, UserInfoSettingsSection, Codable {
  var rgbLight: Bool
  var randomQuotes: Bool
  var sleep: Bool
  var reset: Bool
  var timeFrame: TimeFrame
  var weatherZip: String
  var sideInfo: SideInfo
  
  init() {
    self.rgbLight = false
    self.randomQuotes = false
    self.sleep = false
    self.reset = false
    self.timeFrame = TimeFrame()
    self.weatherZip = ""
    self.sideInfo = SideInfo()
  }
  
  init(rgbLight: Bool, randomQuotes: Bool, sleep: Bool, reset: Bool, timeFrame: TimeFrame, weatherZip: String, sideInfo: SideInfo) {
    self.rgbLight = rgbLight
    self.randomQuotes = randomQuotes
    self.sleep = sleep
    self.reset = reset
    self.timeFrame = timeFrame
    self.weatherZip = weatherZip
    self.sideInfo = sideInfo
  }
}
