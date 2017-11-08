//
//  SettingsGeneralItem.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/2/17.
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
    }
    
    let randomQuotesCell = CellItem(thumbnailImageName: "thumbnail-randomQuotes", description: "Random Quotes", value: randomQuotes)
    randomQuotesCell.subscribe(observer: randomQuotes as AnyObject) { newValue, _ in
      self.randomQuotes = newValue as! Bool
    }
    
    let sleepCell = CellItem(thumbnailImageName: "thumbnail-sleep", description: "Sleep", value: sleep)
    sleepCell.subscribe(observer: sleep as AnyObject) { newValue, _ in
      self.sleep = newValue as! Bool
    }
    
    let resetCell = CellItem(thumbnailImageName: "thumbnail-sleep", description: "Reset", value: reset)
    resetCell.subscribe(observer: reset as AnyObject) { newValue, _ in
      self.reset = newValue as! Bool
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
