//
//  PeripheralCharacteristicServiceItem.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import CoreBluetooth

final class PeripheralServiceItem: PeripheralAdvertisement {
  private(set) var characteristics: BluetoothCharacteristicDictionary = [:]
  private(set) var advertisementDataTypes: [AdvertisementDataType]?
  var advertisementData: [String: Any]
  
  var service: CBService? {
    didSet {
      guard let service = service else { return }
      
      let bluetoothSpecificUUID = service.uuid
      characteristics[bluetoothSpecificUUID] = service.characteristics
    }
  }
  
  
  init(advertisementData: [String: Any]) {
    self.advertisementData = advertisementData
    self.advertisementDataTypes = (advertisementData.keys).sorted().flatMap { AdvertisementDataType(rawValue: $0) }
  }
}
