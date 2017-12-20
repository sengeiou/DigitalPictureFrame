//
//  CharacteristicServiceItem.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import CoreBluetooth

final class CharacteristicServiceItem {
  typealias BluetoothCharacteristicDictionary = [CBUUID: [CBCharacteristic]]
  
  private(set) var characteristics: BluetoothCharacteristicDictionary = [:]
  var advertisementData: [String: Any]?
  var advertisementDataTypes: [AdvertisementDataType]?
  
  var service: CBService? {
    didSet {
      guard let service = service else { return }
      
      let bluetoothSpecificUUID = service.uuid
      characteristics[bluetoothSpecificUUID] = service.characteristics
    }
  }
  
  
  init(advertisementData: [String: Any]?) {
    self.advertisementData = advertisementData
    self.advertisementDataTypes = (advertisementData!.keys).sorted().flatMap { AdvertisementDataType(rawValue: $0) }
  }
}
