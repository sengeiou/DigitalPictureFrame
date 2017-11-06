//
//  SettingsTimeItem.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/3/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

final class SettingsTimeItem: TimeSettingsSection, DigitalPictureFrameItem {
  var timeFrame: TimeFrame
  
  let type = DigitalPictureFrameCellType.timeFrameSettings
  let section = DigitalPictureFrameCellSectionType.time
  var cells: [CellItem] {
    let offTimeCell = CellItem(thumbnailImageName: "thumbnail-Time", description: "Off Time", value: timeFrame.offTime)
    let onTimeCell = CellItem(thumbnailImageName: "thumbnail-Time", description: "On Time", value: timeFrame.onTime)
    return [onTimeCell, offTimeCell]
  }
  
  
  init(timeFrame: TimeFrame) {
    self.timeFrame = timeFrame
  }
}
