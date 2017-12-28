//
//  BluetoothPeripheralDataModelDelegate.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth

typealias BluetoothCharacteristicDictionary = [CBUUID: [CBCharacteristic]]

protocol BluetoothPeripheralDataModelDelegate: class, UITableViewDataSource, UITableViewDelegate {
  var peripheralServiceItem: PeripheralServiceItem? { get set }
  
  init(peripheralServiceItem: PeripheralServiceItem?)
}



// MARK: - Peripheral Services
extension BluetoothPeripheralDataModelDelegate {
  
  var peripheralServices: [CBService]? {
    return BluetoothManager.shared().connectedPeripheral?.services
  }
  
}
