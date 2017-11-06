//
//  UserItem.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/2/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

final class UserItem: DigitalPictureFrameItem {
  private(set) var users: [User]
  
  let type = DigitalPictureFrameCellType.user
  let section = DigitalPictureFrameCellSectionType.users
  var cells: [CellItem] {
    return users.map { CellItem(thumbnailImageName: $0.image, description: $0.description, value: $0.enabled) }
  }
  
  
  init(users: [User]) {
    self.users = users
  }
}
