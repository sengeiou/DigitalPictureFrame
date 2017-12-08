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

struct PeripheralItem {
  var name: String
  var peripheral: CBPeripheral?
  var RSSI: Float
  var statusIcon: UIImage?
  
  
  init(name: String, peripheral: CBPeripheral? = nil, RSSI: Float, statusIcon: UIImage? = UIImage(named: "icon-bluetooth-disconnected")) {
    self.name = name
    self.peripheral = peripheral
    self.RSSI = RSSI
    self.statusIcon = statusIcon
  }
}
