//
//  SideInfo.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

final class SideInfo: Codable {
  enum Keys: String {
    case leftUserName
    case rightUserName
  }
  
  var leftUserName: String
  var rightUserName: String
  
  init() {
    self.leftUserName = ""
    self.rightUserName = ""
  }
  
  init(leftUserName: String, rightUserName: String) {
    self.leftUserName = leftUserName
    self.rightUserName = rightUserName
  }
}
