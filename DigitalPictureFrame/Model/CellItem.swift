//
//  CellItem.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/2/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit

struct CellItem {
  var thumbnailImageName: String
  var description: String
  var value: Any
  
  init(thumbnailImageName: String, description: String, value: Any) {
    self.thumbnailImageName = thumbnailImageName
    self.description = description
    self.value = value
  }
}
