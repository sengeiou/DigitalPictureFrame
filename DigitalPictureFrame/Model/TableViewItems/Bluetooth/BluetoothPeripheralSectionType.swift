//
//  BluetoothPeripheralSectionType.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit

enum BluetoothPeripheralSectionType: Int {
  case advertisementData = 0
  case serviceInfo = 1
  case characteristicInfo = 2
}


// MARK: Header and Cell Height
extension BluetoothPeripheralSectionType {
  
  static var sectionHeaderHeight: CGFloat {
    return 45
  }
  
  static var sectionCellHeight: CGFloat {
    return 70
  }
    
}
