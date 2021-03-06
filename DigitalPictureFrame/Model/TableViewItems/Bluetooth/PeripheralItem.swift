//
//  BluetoothItem.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth

final class PeripheralItem: NSObject, PeripheralAdvertisement {
  var peripheral: CBPeripheral
  var advertisementData: [String: Any]
  var RSSI: Float
  var name: String
  var signalStrengthIcon: UIImage?
  
  
  init(peripheral: CBPeripheral, advertisementData: [String: Any], RSSI: Float, signalStrengthIcon: UIImage? = nil) {
    self.peripheral = peripheral
    self.advertisementData = advertisementData
    self.RSSI = RSSI
    self.name = peripheral.name ?? NSLocalizedString("BLUETOOTH_CONNECTIVITY_PERIPHERAL_ITEM_LABEL_UNNAMED", comment: "")
    self.signalStrengthIcon = signalStrengthIcon
  }
}
