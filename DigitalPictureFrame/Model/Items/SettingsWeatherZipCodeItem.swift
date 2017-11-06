//
//  SettingsWeatherZipCodeItem.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/3/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

final class SettingsWeatherZipCodeItem: ZipCodeSettingsSection, DigitalPictureFrameItem {
  var weatherZip: String
  let type = DigitalPictureFrameCellType.weatherZipcodeSettings
  let section = DigitalPictureFrameCellSectionType.zipCode
  var cells: [CellItem] {
    let leftInfoCell = CellItem(thumbnailImageName: "thumbnail-weatherZip", description: "Weather Zip Code", value: weatherZip)
    return [leftInfoCell]
  }
  
  init(weatherZip: String) {
    self.weatherZip = weatherZip
  }
}
