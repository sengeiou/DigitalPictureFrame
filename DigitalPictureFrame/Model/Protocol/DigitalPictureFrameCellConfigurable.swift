//
//  DigitalPictureFrameCellConfigurable.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit

protocol DigitalPictureFrameCellConfigurable: class {
  var rowInSection: Int? { get set }
  var item: DigitalPictureFrameItem? { get set }
}


// MARK: - Setup item
extension DigitalPictureFrameCellConfigurable where Self: UITableViewCell {
  
  func configure(by item: DigitalPictureFrameItem, at indexPath: IndexPath) {
    self.rowInSection = indexPath.row
    self.item = item
  }
  
}

