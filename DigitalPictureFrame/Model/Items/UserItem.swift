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
    return users.map { user in
      let cell = CellItem(thumbnailImageName: user.image, description: user.description, value: user.enabled)
      cell.subscribe(observer: user) { newValue, _ in
        user.enabled = newValue as! Bool
      }
      return cell
    }
  }
  
  
  init(users: [User]) {
    self.users = users
  }
}
