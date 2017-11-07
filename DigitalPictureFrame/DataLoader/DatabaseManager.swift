//
//  DatabaseManager.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/4/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

final class DatabaseManager {
  private static var sharedInstance: DatabaseManager!
  fileprivate var data: DigitalPictureFrameData
  
  
  static func shared(data: DigitalPictureFrameData? = nil) -> DatabaseManager {
    switch (sharedInstance, data) {
    case let (nil, frameData?):
      sharedInstance = DatabaseManager(data: frameData)
      return sharedInstance
      
    case let (shared?, nil):
      return shared
      
    case let (shared?, _?):
      return shared
      
    default:
      sharedInstance = DatabaseManager()
      return sharedInstance
    }
  }
  
  
  private convenience init(data: DigitalPictureFrameData) {
    self.init()
    self.data = data
  }
  
  private init() {
    self.data = DigitalPictureFrameData()
    DatabaseManager.sharedInstance = self
  }

}


// MARK: - Retrive data
extension DatabaseManager {
  
  var users: [User] {
    return data.users
  }
  
  var settings: Settings {
    return data.settings
  }
  
  var wifiInfo: WiFiInfo {
    return data.wifiInfo
  }
  
}

