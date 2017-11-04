//
//  UserItem.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/2/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

final class UserItem: DigitalPictureFrameItem {
  typealias ItemModel = User
  private var users: [User]
  
  var type = DigitalPictureFrameCellType.imageDescriptionSwitch
  var section = DigitalPictureFrameCellSectionType.users
  var cells: [CellItem<ItemModel>]
  
  
  init(users: [User]) {
    self.users = users
    self.cells = users.map { CellItem<User>(entity: $0) }
  }
}
