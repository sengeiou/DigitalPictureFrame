//
//  Defragmenter.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

struct Defragmenter {
  
  static func defragmentise(data: [Data]) -> Data? {
    guard data.isEmpty == false else { return nil }
    
    var totalData = Data()
    data.forEach { totalData.append($0) }
    return totalData
  }
}
