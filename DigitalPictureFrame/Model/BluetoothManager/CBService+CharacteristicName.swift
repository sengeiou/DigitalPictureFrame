//
//  CBService+CharacteristicName.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import CoreBluetooth

extension CBService {
  /// Obtain the name of the characteristic according to the UUID, if the UUID is the standard defined in the `Bluetooth Developer Portal` then return the name
  var characteristicName: String {
    if self.uuid.name != "" {
      return self.uuid.name
    } else {
      return "UUID: " + self.uuid.uuidString
    }
  }
  
}
