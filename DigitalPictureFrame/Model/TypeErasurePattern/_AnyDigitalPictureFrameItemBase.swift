//
//  _AnyDigitalPictureFrameItemBase.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/3/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

class _AnyDigitalPictureFrameItemBase<ItemModel>: DigitalPictureFrameItem {

  var type: DigitalPictureFrameCellType {
    get { fatalError("Must override") }
    set { fatalError("Must override") }
  }
  
  var section: DigitalPictureFrameCellSectionType {
    get { fatalError("Must override") }
    set { fatalError("Must override") }
  }
  
  var cells: [CellItem<ItemModel>] {
    get { fatalError("Must override") }
    set { fatalError("Must override") }
  }
  
  
  init() {
//    guard type(of: self) != _AnyDigitalPictureFrameItemBase.self else {
//      fatalError("_AnyDigitalPictureFrameItemBase<ItemModel> instances can not be created. Create a subclass instance instead")
//    }
  }
}
