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
    let randomQuotesCell = CellItem(thumbnailImageName: "thumbnail-randomQuotes", description: "Random Quotes", value: randomQuotes)
    let sleepCell = CellItem(thumbnailImageName: "thumbnail-sleep", description: "Sleep", value: sleep)
    let resetCell = CellItem(thumbnailImageName: "thumbnail-sleep", description: "Reset", value: reset)
    return [rgbLightCell, randomQuotesCell, sleepCell, resetCell]
  }
  
  
  init(rgbLight: Bool, randomQuotes: Bool, sleep: Bool, reset: Bool) {
    self.rgbLight = rgbLight
    self.randomQuotes = randomQuotes
    self.sleep = sleep
    self.reset = reset
  }
}
