//
//  SettingsUserInfoItem.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

final class SettingsUserInfoItem: NSObject, UserInfoSettingsSection, DigitalPictureFrameItem {
  var sideInfo: SideInfo
  
  let type = DigitalPictureFrameCellType.userInfoSettings
  let section = DigitalPictureFrameCellSectionType.userInfo
  var cells: [CellItem] {
    let leftInfoCell = CellItem(thumbnailImageName: "thumbnail-infoSide", description: "Left Side", value: sideInfo.leftUserName)
    leftInfoCell.subscribe(observer: sideInfo) { newValue, _ in
      self.sideInfo.leftUserName = newValue as! String
      DatabaseManager.shared().updateSettings(leftSideInfo: self.sideInfo)
    }
    
    let rightInfoCell = CellItem(thumbnailImageName: "thumbnail-infoSide", description: "Right Side", value: sideInfo.rightUserName)
    rightInfoCell.subscribe(observer: sideInfo) { newValue, _ in
      self.sideInfo.rightUserName = newValue as! String
      DatabaseManager.shared().updateSettings(rightSideInfo: self.sideInfo)
    }
    return [leftInfoCell, rightInfoCell]
  }
  
  init(sideInfo: SideInfo) {
    self.sideInfo = sideInfo
  }
}
