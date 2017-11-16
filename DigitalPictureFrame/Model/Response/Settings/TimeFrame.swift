//
//  TimeFrame.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

final class TimeFrame: Codable {
  enum Keys: String {
    case onTime
    case offTime
  }
  
  var onTime: String
  var offTime: String
  
  init() {
    onTime = ""
    offTime = ""
  }
  
  init(onTime: String, offTime: String) {
    self.onTime = onTime
    self.offTime = offTime
  }
}
