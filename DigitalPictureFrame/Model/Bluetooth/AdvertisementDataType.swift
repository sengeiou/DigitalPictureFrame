//
//  AdvertisementDataType.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import CoreBluetooth


enum AdvertisementDataType: String {
  case localNameKey = "kCBAdvDataLocalName"
  case txPowerLevelKey = "kCBAdvDataTxPowerLevel"
  case serviceUUIDsKey = "kCBAdvDataServiceUUIDs"
  case serviceDataKey = "kCBAdvDataServiceData"
  case manufacturerDataKey = "kCBAdvDataManufacturerData"
  case overflowServiceUUIDsKey = "kCBAdvDataOverflowServiceUUIDs"
  case isConnectable = "kCBAdvDataIsConnectable"
  case solicitedServiceUUIDsKey = "kCBAdvDataSolicitedServiceUUIDs"
}

// MARK: CustomStringCon
extension AdvertisementDataType: CustomStringConvertible {
  
  var description: String {
    switch self {
    case .localNameKey:
      return "Local Name"
      
    case .txPowerLevelKey:
      return "Tx Power Level"
      
    case .serviceUUIDsKey:
      return "Service UUIDs"
      
    case .serviceDataKey:
      return "Service Data"
      
    case .manufacturerDataKey:
      return "Manufacturer Data"
      
    case .overflowServiceUUIDsKey:
      return "Overfolow Service UUIDs"
      
    case .isConnectable:
      return "Device is Connectable"
      
    case .solicitedServiceUUIDsKey:
      return "Solicited Service UUIDs"
    }
  }
}


// MARK: -
extension AdvertisementDataType {
  
  func getStringValue(from data: [String: Any]) -> String {
    var resultString = ""
    
    switch self {
    case .localNameKey:
      resultString = data[CBAdvertisementDataLocalNameKey] as? String ?? ""
      
    case .txPowerLevelKey:
      resultString = data[CBAdvertisementDataTxPowerLevelKey] as? String ?? ""
      
    case .serviceUUIDsKey:
      if let serviceUUIDs = data[CBAdvertisementDataServiceUUIDsKey] as? NSArray {
        serviceUUIDs.forEach { resultString = resultString + "\($0)," }
        
        print(resultString)
        resultString = resultString.substring(to: resultString.characters.index(resultString.endIndex, offsetBy: -1))
      } else {
        return ""
      }
      
    case .serviceDataKey:
      let data = (data[CBAdvertisementDataServiceDataKey]!) as? NSDictionary
      if data == nil {
        return ""
      }
      print("\(data!)")
      resultString = data!.description.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
      
    case .manufacturerDataKey:
      resultString = ((data[CBAdvertisementDataManufacturerDataKey] as? Data)?.description)!
    
    case .overflowServiceUUIDsKey:
      resultString = ""
    
    case .isConnectable:
      if let connectable = data[self.rawValue] as? NSNumber {
        resultString = connectable.boolValue ? "true" : "false"
      }
      
    case .solicitedServiceUUIDsKey:
      resultString = ""
    }
    
    return resultString
  }
  
}
