//
//  DigitalPictureFrameCellSetupable.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/3/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit

protocol DigitalPictureFrameCellSetupable: class {
  var rowInSection: Int? { get set }
  var item: DigitalPictureFrameItem? { get set }
}


// MARK: - Setup item
extension DigitalPictureFrameCellSetupable where Self: UITableViewCell {
  
  func setup(by item: DigitalPictureFrameItem, at indexPath: IndexPath) {
    self.rowInSection = indexPath.row
    self.item = item
  }
  
}

