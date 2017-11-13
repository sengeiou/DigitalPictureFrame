//
//  SettingsWeatherZipCodeItem.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

final class SettingsWeatherZipCodeItem: ZipCodeSettingsSection, DigitalPictureFrameItem {
  var weatherZip: String
  let type = DigitalPictureFrameCellType.weatherZipcodeSettings
  let section = DigitalPictureFrameCellSectionType.zipCode
  var cells: [CellItem] {
    let leftInfoCell = CellItem(thumbnailImageName: "thumbnail-weatherZip", description: "Weather Zip Code", value: weatherZip)
    leftInfoCell.subscribe(observer: weatherZip as AnyObject) { newValue, _ in
      self.weatherZip = newValue as! String
    }
    return [leftInfoCell]
  }
  
  init(weatherZip: String) {
    self.weatherZip = weatherZip
  }
}
