//
//  CBAdvertisementData.swift
//  Swift-LightBlue
//
//  Created by Pluto Y on 16/1/21.
//  Copyright © 2016年 Pluto-y. All rights reserved.
//

import Foundation
import CoreBluetooth





class CBAdvertisementData {
  
  static func getAdvertisementDataName(_ key: String) -> String {
    if key == CBAdvertisementDataLocalNameKey {
      return "Local Name"
      
    } else if key == CBAdvertisementDataTxPowerLevelKey {
      return "Tx Power Level"
      
    } else if key == CBAdvertisementDataServiceUUIDsKey {
      return "Service UUIDs"
      
    } else if key == CBAdvertisementDataServiceDataKey {
      return "Service Data"
      
    } else if key == CBAdvertisementDataManufacturerDataKey {
      return "Manufacturer Data"
      
    } else if key == CBAdvertisementDataOverflowServiceUUIDsKey {
      return "Overfolow Service UUIDs"
      
    } else if key == CBAdvertisementDataIsConnectable{
      return "Device is Connectable"
      
    } else if key == CBAdvertisementDataSolicitedServiceUUIDsKey {
      return "Solicited Service UUIDs"
    }
    
    return key
  }
  
  
  static func getAdvertisementDataStringValue(_ datas: [String: Any], key : String) -> String {
    var resultString = ""
    
    switch key {
    case let key where key == CBAdvertisementDataLocalNameKey:
      print(key)
      
    case let key where key == CBAdvertisementDataTxPowerLevelKey:
      print(key)
      
    case let key where key == CBAdvertisementDataServiceUUIDsKey:
      print(key)
      
    case let key where key == CBAdvertisementDataServiceDataKey:
      print(key)
      
    case let key where key == CBAdvertisementDataManufacturerDataKey:
      print(key)
    
    case let key where key == CBAdvertisementDataOverflowServiceUUIDsKey:
      print(key)
    
    case let key where key == CBAdvertisementDataIsConnectable:
      print(key)
      
    case let key where key == CBAdvertisementDataSolicitedServiceUUIDsKey:
      print(key)
      
    default:
      print(key)
    }
    
    
    if key == CBAdvertisementDataLocalNameKey {
      resultString = datas[CBAdvertisementDataLocalNameKey] as? String ?? ""
      
    } else if key == CBAdvertisementDataTxPowerLevelKey {
      resultString = datas[CBAdvertisementDataTxPowerLevelKey] as? String ?? ""
      
    } else if key == CBAdvertisementDataServiceUUIDsKey {
      if let serviceUUIDs = datas[CBAdvertisementDataServiceUUIDsKey] as? NSArray {
        serviceUUIDs.forEach { resultString = resultString + "\($0)," }
        
        print(resultString)
        resultString = resultString.substring(to: resultString.characters.index(resultString.endIndex, offsetBy: -1))
      } else {
        return ""
      }
      
    } else if key == CBAdvertisementDataServiceDataKey {
      let data = (datas[CBAdvertisementDataServiceDataKey]!) as? NSDictionary
      if data == nil {
        return ""
      }
      print("\(data!)")
      resultString = data!.description.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
      
    } else if key == CBAdvertisementDataManufacturerDataKey {
      resultString = ((datas[CBAdvertisementDataManufacturerDataKey] as? Data)?.description)!
      
    } else if key == CBAdvertisementDataOverflowServiceUUIDsKey {
      resultString = ""
      
    } else if key == CBAdvertisementDataIsConnectable {
      if let connectable = datas[key] as? NSNumber {
        resultString = connectable.boolValue ? "true" : "false"
      }
    } else if key == CBAdvertisementDataSolicitedServiceUUIDsKey {
      resultString = ""
    }
    
    return resultString
  }
  
}
