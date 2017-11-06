//
//  DigitalPictureFrameItem.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/2/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

protocol DigitalPictureFrameItem {
  var type: DigitalPictureFrameCellType { get }
  var section: DigitalPictureFrameCellSectionType { get }
  var cells: [CellItem] { get }
}
