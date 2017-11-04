//
//  Settings.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/2/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

struct Settings: GeneralSettingsSection, TimeSettingsSection, ZipCodeSettingsSection, UserInfoSettingsSection, CustomStringConvertible, Codable {
  var rgbLight: Bool
  var randomQuotes: Bool
  var sleep: Bool
  var timeFrame: TimeFrame
  var weatherZip: String
  var sideInfo: SideInfo
}


// MARK: - CustomStringConvertible protocol
extension Settings {
  
  var description: String {
    return weatherZip
  }
  
}
