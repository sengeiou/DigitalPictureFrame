//
//  WiFiInfo.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/2/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

final class WiFiInfo: Codable, CustomStringConvertible {
  var name: String
  var password: String
  
  init() {
    self.name = ""
    self.password = ""
  }
  
  init(name: String, password: String) {
    self.name = name
    self.password = password
  }
}

// MARK: CustomStringConvertible protocol
extension WiFiInfo {
  
  var description: String {
    return name
  }
}
