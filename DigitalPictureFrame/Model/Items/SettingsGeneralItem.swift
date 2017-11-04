//
//  SettingsGeneralItem.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/2/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

final class SettingsGeneralItem: GeneralSettingsSection, DigitalPictureFrameItem {
  typealias ItemModel = [String: Bool]
  
  var rgbLight: Bool
  var randomQuotes: Bool
  var sleep: Bool
  var type = DigitalPictureFrameItemType.imageDescriptionSwitch
  var section = DigitalPictureFrameItemSectionType.general
  var cells: [CellItem<ItemModel>]
  
  
  init(rgbLight: Bool, randomQuotes: Bool, sleep: Bool) {
    self.rgbLight = rgbLight
    self.randomQuotes = randomQuotes
    self.sleep = sleep
    
    let dict = ["rgbLight": rgbLight, "randomQuotes": randomQuotes, "sleep": sleep]
    let generalCells = CellItem(entity: dict)
    cells = [generalCells]
  }
}
