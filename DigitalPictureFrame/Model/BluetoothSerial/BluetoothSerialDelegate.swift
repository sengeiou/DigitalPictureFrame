//
//  BluetoothSerialDelegate.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import CoreBluetooth


@objc protocol BluetoothSerialDelegate {
  /// Called when the state of the CBCentralManager changes (e.g. when bluetooth is turned on/off)
  func serialDidChangeState()
  
  /// Called when a peripheral disconnected
  func serialDidDisconnect(_ peripheral: CBPeripheral, error: NSError?)
  
  /// Called when a message is received
  @objc optional func serialDidReceiveString(_ message: String)
  
  /// Called when a message is received
  @objc optional func serialDidReceiveBytes(_ bytes: [UInt8])
  
  /// Called when a message is received
  @objc optional func serialDidReceiveData(_ data: Data)
  
  /// Called when the RSSI of the connected peripheral is read
  @objc optional func serialDidReadRSSI(_ rssi: NSNumber)
  
  /// Called when a new peripheral is discovered while scanning. Also gives the RSSI (signal strength)
  @objc optional func serialDidDiscoverPeripheral(_ peripheral: CBPeripheral, RSSI: NSNumber?)
  
  /// Called when a peripheral is connected (but not yet ready for cummunication)
  @objc optional func serialDidConnect(_ peripheral: CBPeripheral)
  
  /// Called when a pending connection failed
  @objc optional func serialDidFailToConnect(_ peripheral: CBPeripheral, error: NSError?)
  
  /// Called when a peripheral is ready for communication
  @objc optional func serialIsReady(_ peripheral: CBPeripheral)
  
  
  
  /// MARK: -TEST
  @objc optional func fakeSerialDidDiscoverPeripheral(_ peripheral: PeripheralItem, RSSI: NSNumber?)
}

