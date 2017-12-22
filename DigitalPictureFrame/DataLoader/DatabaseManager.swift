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
  
  func retrieve(completionHandler: @escaping (NetworkResultType<DigitalPictureFrameData, NetworkError>)->()) {
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

}


// MARK: - Update data
extension DatabaseManager {
  
  func updateUser(_ user: User) {
    guard let users = self.users, let userIndex = users.index(of: user) else { return }
    databaseReference.child("\(DigitalPictureFrameData.Keys.users.rawValue)/\(userIndex)").updateChildValues(["\(User.Keys.enabled.rawValue)": user.enabled])
  }
  
  func updateSettings(general: Any, key: String) {
    databaseReference.child(DigitalPictureFrameData.Keys.settings.rawValue).updateChildValues(["\(key)": general])
  }
  
  func updateSettings(timeFrameOn: TimeFrame) {
    databaseReference.child("\(DigitalPictureFrameData.Keys.settings.rawValue)/\(Settings.Keys.timeFrame.rawValue)").updateChildValues([TimeFrame.Keys.onTime.rawValue: timeFrameOn.onTime])
  }
  
  func updateSettings(timeFrameOff: TimeFrame) {
    databaseReference.child("\(DigitalPictureFrameData.Keys.settings.rawValue)/\(Settings.Keys.timeFrame.rawValue)").updateChildValues([TimeFrame.Keys.offTime.rawValue: timeFrameOff.offTime])
  }
  
  func updateSettings(leftSideInfo: SideInfo) {
    guard let _ = self.settings else { return }
    databaseReference.child("\(DigitalPictureFrameData.Keys.settings.rawValue)/\(Settings.Keys.sideInfo.rawValue)").updateChildValues([SideInfo.Keys.leftUserName.rawValue: leftSideInfo.leftUserName])
  }
  
  func updateSettings(rightSideInfo: SideInfo) {
    guard let _ = self.settings else { return }
    databaseReference.child("\(DigitalPictureFrameData.Keys.settings.rawValue)/\(Settings.Keys.sideInfo.rawValue)").updateChildValues([SideInfo.Keys.rightUserName.rawValue: rightSideInfo.rightUserName])
  }
  
  func updateSettings(weatherZipcode: String) {
    guard let _ = self.settings else { return }
    databaseReference.child(DigitalPictureFrameData.Keys.settings.rawValue).updateChildValues([Settings.Keys.weatherZip.rawValue: weatherZipcode])
  }
  
  func updateWiFiInfo(_ wifiInfo: WiFiInfo) {
    guard let _ = self.wifiInfo else { return }
    databaseReference.child(DigitalPictureFrameData.Keys.wifiInfo.rawValue).updateChildValues([WiFiInfo.Keys.name.rawValue: wifiInfo.name])
    databaseReference.child(DigitalPictureFrameData.Keys.wifiInfo.rawValue).updateChildValues([WiFiInfo.Keys.password.rawValue: wifiInfo.password])
  }
  
  func clearData() {
    data = nil
  }
  
}


// MARK: - Properties
extension DatabaseManager {
  
  var phoneNumber: String? {
    return data?.phoneNumber
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
  
  
  var encodedJsonData: Data? {
    if let data = data, let encodedData = try? JSONEncoder().encode(data) {
      if let _ = try? JSONSerialization.jsonObject(with: encodedData, options: .allowFragments) {
        //          print("DigitalPictureFrameData JSON:\n" + String(describing: json) + "\n")
        return encodedData
      }
    }
    
    return nil
  }
  
}
