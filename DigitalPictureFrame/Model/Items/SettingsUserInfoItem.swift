//
//  SettingsUserInfoItem.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/3/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

final class SettingsUserInfoItem: NSObject, UserInfoSettingsSection, DigitalPictureFrameItem {
  var sideInfo: SideInfo
  
  let type = DigitalPictureFrameCellType.userInfoSettings
  let section = DigitalPictureFrameCellSectionType.userInfo
  var cells: [CellItem] {
    let leftInfoCell = CellItem(thumbnailImageName: "thumbnail-infoSide", description: "User Info Left Side", value: sideInfo.leftUserName)
    let rightInfoCell = CellItem(thumbnailImageName: "thumbnail-infoSide", description: "User Info Right Side", value: sideInfo.rightUserName)
    return [leftInfoCell, rightInfoCell]
  }
  
  init(sideInfo: SideInfo) {
    self.sideInfo = sideInfo
  }
}
