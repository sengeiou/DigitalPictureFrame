//
//  User.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

final class User: Codable, Equatable {
  enum Keys: String {
    case name
    case image
    case enabled
  }
  
  var name: String
  var image: String
  var enabled: Bool
  
  init(name: String, image: String, enabled: Bool) {
    self.name = name
    self.image = image
    self.enabled = enabled
  }
}

// MARK: CustomStringConvertible protocol
extension User: CustomStringConvertible {
  
  var description: String {
    return name
  }
  
}

func ==(lhs: User, rhs: User) -> Bool {
  return lhs.name == rhs.name
}
