//
//  WiFiItem.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/2/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

final class WiFiItem: DigitalPictureFrameItem {
  typealias ItemModel = WiFiInfo
  private var wiFi: WiFiInfo
  
  var type = DigitalPictureFrameItemType.imageDescriptionRightText
  var section = DigitalPictureFrameItemSectionType.wifi
  var cells: [CellItem<ItemModel>]
  
  
  init(wiFi: WiFiInfo) {
    self.wiFi = wiFi
    self.cells = [CellItem(entity: wiFi)]
  }
}
