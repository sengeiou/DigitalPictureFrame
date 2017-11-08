//
//  WiFiItem.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/2/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit

final class WiFiItem: DigitalPictureFrameItem {
  private(set) var wiFi: WiFiInfo
  
  let type = DigitalPictureFrameCellType.wifi
  let section = DigitalPictureFrameCellSectionType.wifi
  var cells: [CellItem] {
    let wifiCell = CellItem(thumbnailImageName: "thumbnail-wifi-on", description: wiFi.description, value: wiFi.password)
    wifiCell.subscribe(observer: wiFi) { newValue, _ in
      self.wiFi.password = newValue as! String
    }
    
    return [wifiCell]
  }
  
  
  init(wiFi: WiFiInfo) {
    self.wiFi = wiFi
  }
}
