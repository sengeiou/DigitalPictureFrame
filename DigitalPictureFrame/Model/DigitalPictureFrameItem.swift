//
//  DigitalPictureFrameItem.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/2/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

protocol DigitalPictureFrameItem {
  associatedtype ItemModel
  
  var type: DigitalPictureFrameCellType { get set }
  var section: DigitalPictureFrameCellSectionType { get set }
  var cells: [CellItem<ItemModel>] { get set }
}
