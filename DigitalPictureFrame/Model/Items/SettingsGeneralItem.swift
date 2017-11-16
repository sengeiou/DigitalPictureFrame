//
//  SettingsGeneralItem.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

final class SettingsGeneralItem: GeneralSettingsSection, DigitalPictureFrameItem {
  var rgbLight: Bool
  var randomQuotes: Bool
  var sleep: Bool
  var reset: Bool
  let type = DigitalPictureFrameCellType.generalSettings
  let section = DigitalPictureFrameCellSectionType.general
  var cells: [CellItem] {
    let rgbLightCell = CellItem(thumbnailImageName: "thumbnail-rgbLight", description: "RGB Light", value: rgbLight)
    rgbLightCell.subscribe(observer: rgbLight as AnyObject) { newValue, _ in
      self.rgbLight = newValue as! Bool
      DatabaseManager.shared().updateSettings(general: self.rgbLight, key: Settings.Keys.rgbLight.rawValue)
    }
    
    let randomQuotesCell = CellItem(thumbnailImageName: "thumbnail-randomQuotes", description: "Random Quotes", value: randomQuotes)
    randomQuotesCell.subscribe(observer: randomQuotes as AnyObject) { newValue, _ in
      self.randomQuotes = newValue as! Bool
      DatabaseManager.shared().updateSettings(general: self.randomQuotes, key: Settings.Keys.randomQuotes.rawValue)
    }
    
    
    let sleepCell = CellItem(thumbnailImageName: "thumbnail-sleep", description: "Sleep", value: sleep)
    sleepCell.subscribe(observer: sleep as AnyObject) { newValue, _ in
      self.sleep = newValue as! Bool
      DatabaseManager.shared().updateSettings(general: self.sleep, key: Settings.Keys.sleep.rawValue)
    }
    
    
    let resetCell = CellItem(thumbnailImageName: "thumbnail-sleep", description: "Reset", value: reset)
    resetCell.subscribe(observer: reset as AnyObject) { newValue, _ in
      self.reset = newValue as! Bool
      DatabaseManager.shared().updateSettings(general: self.reset, key: Settings.Keys.reset.rawValue)
    }
    
    return [rgbLightCell, randomQuotesCell, sleepCell, resetCell]
  }
  
  
  init(rgbLight: Bool, randomQuotes: Bool, sleep: Bool, reset: Bool) {
    self.rgbLight = rgbLight
    self.randomQuotes = randomQuotes
    self.sleep = sleep
    self.reset = reset
  }
}
