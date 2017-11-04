//
//  AnyDigitalPictureFrameItem.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/3/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

final class AnyDigitalPictureFrameItem<ItemModel>: DigitalPictureFrameItem {
  private let box: _AnyDigitalPictureFrameItemBase<ItemModel>
  
  // Initializer takes our concrete implementer of DigitalPictureFrameItem i.e. UserItem
  init<Concrete: DigitalPictureFrameItem>(_ concrete: Concrete) where Concrete.ItemModel == ItemModel {
    box = _AnyDigitalPictureFrameItemBox(concrete)
  }
  
  var type: DigitalPictureFrameItemType {
    get {
      return box.type
    }
    set {
      box.type = newValue
    }
  }
  
  var section: DigitalPictureFrameItemSectionType {
    get {
      return box.section
    }
    set {
      box.section = newValue
    }
  }
  
  var cells: [CellItem<ItemModel>] {
    get {
      return box.cells
    }
    set {
      box.cells = newValue
    }
  }

}

