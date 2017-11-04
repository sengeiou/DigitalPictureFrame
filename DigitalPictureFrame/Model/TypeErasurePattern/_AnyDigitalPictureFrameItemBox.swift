//
//  _AnyDigitalPictureFrameItemBox.swift
//  GoogleToolboxForMac
//
//  Created by Pawel Milek on 11/3/17.
//

import Foundation

class _AnyDigitalPictureFrameItemBox<Concrete: DigitalPictureFrameItem>: _AnyDigitalPictureFrameItemBase<Concrete.ItemModel> {
  // Variable used since we're calling mutating functions
  var concrete: Concrete
  
  init(_ concrete: Concrete) {
    self.concrete = concrete
  }

  
  // Trampoline property accessors along to base
  override var type: DigitalPictureFrameItemType  {
    get {
      return concrete.type
    }
    set {
      concrete.type = newValue
    }
  }
  
  override var section: DigitalPictureFrameItemSectionType {
    get {
      return concrete.section
    }
    set {
      concrete.section = newValue
    }
  }
  
  override var cells: [CellItem<ItemModel>] {
    get {
      return concrete.cells
    }
    set {
      concrete.cells = newValue
    }
  }
}

