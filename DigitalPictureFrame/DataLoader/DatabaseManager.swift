//
//  DatabaseManager.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import Firebase

final class DatabaseManager {
  private static var sharedInstance: DatabaseManager!
  private var databaseReference: DatabaseReference
  private var data: DigitalPictureFrameData?
  
  
  static func shared(data: DigitalPictureFrameData? = nil) -> DatabaseManager {
    switch (sharedInstance, data) {
    case let (nil, frameData?):
      self.sharedInstance = DatabaseManager(data: frameData)
      return self.sharedInstance
      
    case let (shared?, nil):
      return shared
      
    case let (_?, frameData?):
      self.sharedInstance = DatabaseManager(data: frameData)
      return self.sharedInstance
      
    default:
      self.sharedInstance = DatabaseManager()
      return self.sharedInstance
    }
  }
  
  
  private convenience init(data: DigitalPictureFrameData) {
    self.init()
    self.data = data
  }
  
  private init() {
    self.databaseReference = Database.database().reference()
    self.data = DigitalPictureFrameData()
    DatabaseManager.sharedInstance = self
  }
}


// MARK: - Retrieve and update data
extension DatabaseManager {
  
  func retrieveData(completionHandler: @escaping (NetworkResultType<DigitalPictureFrameData, NetworkError>)->()) {
    DispatchQueue.main.async {
      self.databaseReference.observeSingleEvent(of: .value, with: { snapshot in
        if let snapshotDict = snapshot.value as? [String: Any],
          let jsonData = try? JSONSerialization.data(withJSONObject: snapshotDict, options: []) {
          if let digitalFrameData = try? JSONDecoder().decode(DigitalPictureFrameData.self, from: jsonData) {
            completionHandler(.success(digitalFrameData))
          } else {
            completionHandler(.failure(NetworkError.dataNotAvailable))
          }
        } else {
          completionHandler(.failure(NetworkError.dataNotAvailable))
        }
      })
    }
  }

  
  func updateUserData(for user: User) {
    guard let users = users, let userIndex = users.index(of: user) else { return }
    databaseReference.child("users/\(userIndex)").updateChildValues(["enabled": user.enabled])
  }
  
  
  func updateGeneralSettingsData(key: String, value: Any) {
    databaseReference.child("settings/\(key)")
  }
  
  func updateTimeFrameSettingsData(key: String, value: Any) {
    databaseReference.child("settings/\(key)")
  }
  
  func updateUserInfoSettingsData(key: String, value: Any) {
    databaseReference.child("settings/\(key)")
  }
  
  func updateWeatherZipcodeSettingsData(key: String, value: Any) {
    databaseReference.child("settings/\(key)")
  }
  
  func updateWiFiData(key: String, value: Any) {
    databaseReference.child("wifiInof/\(key)")
  }
  
  
  func clearData() {
    data = nil
  }
}


// MARK: - Retrive data
extension DatabaseManager {
  
  var UDID: String? {
    return data?.UDID
  }
  
  var users: [User]? {
    return data?.users
  }
  
  var settings: Settings? {
    return data?.settings
  }
  
  var wifiInfo: WiFiInfo? {
    return data?.wifiInfo
  }
  
}
