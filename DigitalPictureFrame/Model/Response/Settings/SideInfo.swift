//
//  SideInfo.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/2/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

struct SideInfo: Codable {
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
