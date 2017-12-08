//
//  BluetoothSerialSingleton.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

final class BluetoothSerialSingleton {
  static let sharedInstance = BluetoothSerialSingleton()
  
  var serial: BluetoothSerial!
  
  private init() {}
}
