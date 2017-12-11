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

class PeripheralItem: NSObject {
  var peripheral: CBPeripheral?
  var RSSI: Float
  var name: String
  var statusIcon: UIImage?
  
  
  init(peripheral: CBPeripheral? = nil, RSSI: Float, statusIcon: UIImage? = UIImage(named: "icon-bluetooth-disconnected")) {
    self.peripheral = peripheral
    self.RSSI = RSSI
    self.name = peripheral?.name ?? "Not Available"
    self.statusIcon = statusIcon
  }
}
