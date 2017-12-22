//
//  CBCharacteristic+PropertiesDescription.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import CoreBluetooth

extension CBCharacteristic {

  func createPropertiesDescription() -> String {
    let properties: [CharacteristicPropertyType] = getProperties()
    
    let title = "Properties:"
    var description = ""
    let isContainWriteProperty = properties.contains(.write)
    for property in properties {
      if case .writeWithoutResponse = property, isContainWriteProperty { continue }
      description += "-" + property.description
    }
    
    description = String(description.dropFirst())
    return title + " " + description
  }
  
  
  
  func getProperties() -> [CharacteristicPropertyType] {
    let properties = self.properties.rawValue
    
    let broadcast = CharacteristicPropertyType.broadcast
    let read = CharacteristicPropertyType.read
    let writeWithoutResponse = CharacteristicPropertyType.writeWithoutResponse
    let write = CharacteristicPropertyType.write
    let notify = CharacteristicPropertyType.notify
    let indicate = CharacteristicPropertyType.indicate
    let authenticatedSignedWrites = CharacteristicPropertyType.authenticatedSignedWrites
    let extendedProperties = CharacteristicPropertyType.extendedProperties
    let notifyEncryptionRequired = CharacteristicPropertyType.notifyEncryptionRequired
    let indicateEncryptionRequired = CharacteristicPropertyType.indicateEncryptionRequired
    
    var resultProperties = [CharacteristicPropertyType]()

    if properties & broadcast.rawValue > 0 {
      resultProperties.append(broadcast)
    }
    
    if properties & read.rawValue > 0 {
      resultProperties.append(read)
    }
    
    if properties & write.rawValue > 0 {
      resultProperties.append(write)
    }
    
    if properties & writeWithoutResponse.rawValue > 0 {
      resultProperties.append(writeWithoutResponse)
    }
    
    if properties & notify.rawValue > 0 {
      resultProperties.append(notify)
    }
    
    if properties & indicate.rawValue > 0 {
      resultProperties.append(indicate)
    }
    
    if properties & authenticatedSignedWrites.rawValue > 0 {
      resultProperties.append(authenticatedSignedWrites)
    }
    
    if properties & extendedProperties.rawValue > 0 {
      resultProperties.append(extendedProperties)
    }
    
    if properties & notifyEncryptionRequired.rawValue > 0 {
      resultProperties.append(notifyEncryptionRequired)
    }
    
    if properties & indicateEncryptionRequired.rawValue > 0 {
      resultProperties.append(indicateEncryptionRequired)
    }
    
    return resultProperties
  }
}
