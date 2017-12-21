//
//  WiFiItem.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit

final class WiFiItem: DigitalPictureFrameItem {
  private(set) var wiFi: WiFiInfo
  
  let type = DigitalPictureFrameCellType.wifi
  let section = DigitalPictureFrameCellSectionType.wifi
  var cells: [CellItem] {
    let wifiCell = CellItem(thumbnailImageName: "thumbnail-wifi-on", description: wiFi.name, value: wiFi.description)
    wifiCell.subscribe(observer: wiFi) { newValue, _ in
      let nameAndPassword = WiFiInfo.extractComponents(from: newValue as! String)
      
      self.wiFi.name = nameAndPassword.name
      self.wiFi.password = nameAndPassword.password
      DatabaseManager.shared().updateWiFiInfo(self.wiFi)
    }
    
    return [wifiCell]
  }
  
  
  init(wiFi: WiFiInfo) {
    self.wiFi = wiFi
  }
}
