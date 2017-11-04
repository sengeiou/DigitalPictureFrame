//
//  SettingsTimeItem.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/3/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

final class SettingsTimeItem: TimeSettingsSection, DigitalPictureFrameItem {
  typealias ItemModel = TimeFrame
  
  var timeFrame: TimeFrame
  
  var type = DigitalPictureFrameCellType.imageDescriptionSwitch
  var section = DigitalPictureFrameCellSectionType.time
  var cells: [CellItem<ItemModel>]
  
  
  init(timeFrame: TimeFrame) {
    self.timeFrame = timeFrame
    
    let timeCell = CellItem(entity: timeFrame)
    self.cells = [timeCell]
  }
}
