//
//  WiFiInfo.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/2/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

struct WiFiInfo: Codable, CustomStringConvertible {
  var name: String
  var password: String
}

// MARK: - CustomStringConvertible protocol
extension WiFiInfo {
  
  var description: String {
    return name
  }
  
}
