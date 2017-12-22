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
  case deviceInfo = 1
  case transferData = 2
}


// MARK: Header and Cell Height
extension BluetoothPeripheralSectionType {
  
  static var sectionHeaderHeight: CGFloat {
    return 45
  }
  
  var sectionCellHeight: CGFloat {
    switch self {
    case .advertisementData:
      return 50
      
    case .deviceInfo:
      return 75
      
    case .transferData:
      return 115
    }
  }
}
