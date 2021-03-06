//
//  DigitalPictureFrameItem.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

protocol DigitalPictureFrameItem {
  var type: DigitalPictureFrameCellType { get }
  var section: DigitalPictureFrameCellSectionType { get }
  var cells: [CellItem] { get }
}
