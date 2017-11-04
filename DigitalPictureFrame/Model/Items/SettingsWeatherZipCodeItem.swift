//
//  SettingsWeatherZipCodeItem.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/3/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

final class SettingsWeatherZipCodeItem: ZipCodeSettingsSection, DigitalPictureFrameItem {
  typealias ItemModel = String
  
  var weatherZip: String
  var type = DigitalPictureFrameItemType.imageDescriptionSwitch
  var section = DigitalPictureFrameItemSectionType.zipCode
  var cells: [CellItem<ItemModel>]
  
  init(weatherZip: String) {
    self.weatherZip = weatherZip
    self.cells = [CellItem(entity: weatherZip)]
  }
}
