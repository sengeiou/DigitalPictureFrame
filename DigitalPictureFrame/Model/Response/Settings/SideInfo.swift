//
//  SideInfo.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/2/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

struct SideInfo: Codable, CustomStringConvertible {
  var leftUserName: String
  var rightUserName: String
}


// MARK: - CustomStringConvertible protocol
extension SideInfo {
  
  var description: String {
    return leftUserName + ", " + rightUserName
  }
}
