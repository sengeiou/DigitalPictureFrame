//
//  SettingsTimeItem.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

final class SettingsTimeItem: TimeSettingsSection, DigitalPictureFrameItem {
  var timeFrame: TimeFrame
  
  let type = DigitalPictureFrameCellType.timeFrameSettings
  let section = DigitalPictureFrameCellSectionType.time
  var cells: [CellItem] {
    let offTimeCell = CellItem(thumbnailImageName: "thumbnail-Time", description: "Off Time", value: timeFrame.offTime)
    offTimeCell.subscribe(observer: timeFrame) { newValue, _ in
      self.timeFrame.offTime = newValue as! String
      DatabaseManager.shared().updateSettings(timeFrameOff: self.timeFrame)
    }
    
    let onTimeCell = CellItem(thumbnailImageName: "thumbnail-Time", description: "On Time", value: timeFrame.onTime)
    onTimeCell.subscribe(observer: timeFrame) { newValue, oldValue in
      self.timeFrame.onTime = newValue as! String
      DatabaseManager.shared().updateSettings(timeFrameOn: self.timeFrame)
    }
    
    return [onTimeCell, offTimeCell]
  }
  
  
  init(timeFrame: TimeFrame) {
    self.timeFrame = timeFrame
  }
}



