//
//  User.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

final class User: Codable, Equatable {
  var name: String
  var image: String
  var enabled: Bool
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
