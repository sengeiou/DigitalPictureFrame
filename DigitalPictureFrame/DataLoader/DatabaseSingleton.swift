//
//  DatabaseSingleton.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/4/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

final class DatabaseSingleton {
  static let shared = DatabaseSingleton()
  private(set) var data: DigitalPictureFrameData?
  
  
  private init() {}
}


// MARK: - assign(data:
extension DatabaseSingleton {
  
  func assign(data: DigitalPictureFrameData) {
    self.data = data
  }
  
}
