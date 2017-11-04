//
//  SettingsUserInfoItem.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/3/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

final class SettingsUserInfoItem: NSObject, UserInfoSettingsSection, DigitalPictureFrameItem {
  typealias ItemModel = SideInfo
  
  var sideInfo: SideInfo
  
  var type = DigitalPictureFrameItemType.imageDescriptionSwitch
  var section = DigitalPictureFrameItemSectionType.userInfo
  var cells: [CellItem<ItemModel>]
  
  init(sideInfo: SideInfo) {
    self.sideInfo = sideInfo
    self.cells = [CellItem(entity: sideInfo)]
  }
}
