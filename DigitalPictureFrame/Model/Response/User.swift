//
//  User.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/2/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

struct User: Codable, CustomStringConvertible {
  var name: String
  var image: String
  var enabled: Bool
}


// MARK: - CustomStringConvertible protocol
extension User {
  
  var description: String {
    return image + ", " + name
  }
  
}
