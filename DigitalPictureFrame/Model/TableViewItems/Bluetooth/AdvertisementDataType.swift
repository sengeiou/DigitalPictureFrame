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


// MARK: - Get value from Advertisement Data
extension AdvertisementDataType {
  
  func getValue(from data: [String: Any]) -> String {
    var result = ""
    
    switch self {
    case .localNameKey:
      guard let data = data[CBAdvertisementDataLocalNameKey] as? String else { return "" }
      result = data
      
    case .txPowerLevelKey:
      guard let data = data[CBAdvertisementDataTxPowerLevelKey] as? String else { return "" }
      result = data
      
    case .serviceUUIDsKey:
      guard let serviceUUIDs = data[CBAdvertisementDataServiceUUIDsKey] as? NSArray else { return "" }
      serviceUUIDs.forEach { result = result + "\($0)," }
//      print(result)
      result = String(result.dropLast())
      
    case .serviceDataKey:
      guard let data = data[CBAdvertisementDataServiceDataKey] as? NSDictionary else { return "" }
//      print("\(data)")
      result = data.description.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
      
    case .manufacturerDataKey:
      guard let data = data[CBAdvertisementDataManufacturerDataKey] as? Data else { return "" }
      result = data.description
    
    case .overflowServiceUUIDsKey:
      result = ""
    
    case .isConnectable:
      guard let connectable = data[self.rawValue] as? NSNumber else { return "" }
      result = connectable.boolValue ? "true" : "false"
      
    case .solicitedServiceUUIDsKey:
      result = ""
    }
    
    return result
  }
  
}
