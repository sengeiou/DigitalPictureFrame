//
//  BluetoothSerial.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//
//

import UIKit
import CoreBluetooth

final class BluetoothSerial: NSObject {
  var delegate: BluetoothSerialDelegate!
  
  /// The CBCentralManager this bluetooth serial handler uses for... well, everything really
  var centralManager: CBCentralManager!
  
  /// The peripheral we're trying to connect to (nil if none)
  var pendingPeripheral: CBPeripheral?
  
  /// The connected peripheral (nil if none is connected)
  var connectedPeripheral: CBPeripheral?
  
  /// The characteristic 0xFFE1 we need to write to, of the connectedPeripheral
  weak var writeCharacteristic: CBCharacteristic?
  
  /// Whether this serial is ready to send and receive data
  var isReady: Bool {
    get {
      return centralManager.state == .poweredOn && connectedPeripheral != nil && writeCharacteristic != nil
    }
  }
  
  /// Whether this serial is looking for advertising peripherals
  var isScanning: Bool {
    return centralManager.isScanning
  }
  
  /// Whether the state of the centralManager is .poweredOn
  var isPoweredOn: Bool {
    return centralManager.state == .poweredOn
  }
  
  /// UUID of the service to look for.
  var serviceUUID = CBUUID(string: "FFE0")
  
  /// UUID of the characteristic to look for.
  var characteristicUUID = CBUUID(string: "FFE1")
  
  /// Whether to write to the HM10 with or without response. Set automatically.
  /// Legit HM10 modules (from JNHuaMao) require 'Write without Response',
  /// while fake modules (e.g. from Bolutek) require 'Write with Response'.
  private var writeType: CBCharacteristicWriteType = .withoutResponse
  
  
  
  /// Always use this to initialize an instance
  init(delegate: BluetoothSerialDelegate) {
    super.init()
    self.delegate = delegate
    centralManager = CBCentralManager(delegate: self, queue: nil)
  }
  
  /// Start scanning for peripherals
  func startScan() {
    guard centralManager.state == .poweredOn else { return }
    
    // start scanning for peripherals with correct service UUID
    centralManager.scanForPeripherals(withServices: [serviceUUID], options: nil)
    
    // retrieve peripherals that are already connected
    // see this stackoverflow question http://stackoverflow.com/questions/13286487
    let peripherals = centralManager.retrieveConnectedPeripherals(withServices: [serviceUUID])
    for peripheral in peripherals {
      delegate.serialDidDiscoverPeripheral?(peripheral, RSSI: nil)
    }
  }
  
  /// Stop scanning for peripherals
  func stopScan() {
    centralManager.stopScan()
  }
  
  /// Try to connect to the given peripheral
  func connectToPeripheral(_ peripheral: CBPeripheral) {
    pendingPeripheral = peripheral
    centralManager.connect(peripheral, options: nil)
  }
  
  /// Disconnect from the connected peripheral or stop connecting to it
  func disconnect() {
    if let p = connectedPeripheral {
      centralManager.cancelPeripheralConnection(p)
    } else if let p = pendingPeripheral {
      centralManager.cancelPeripheralConnection(p) //TODO: Test whether its neccesary to set p to nil
    }
  }
  
  /// The didReadRSSI delegate function will be called after calling this function
  func readRSSI() {
    guard isReady else { return }
    connectedPeripheral!.readRSSI()
  }
  
  /// Send a string to the device
  func sendMessageToDevice(_ message: String) {
    guard isReady else { return }
    
    if let data = message.data(using: String.Encoding.utf8) {
      connectedPeripheral!.writeValue(data, for: writeCharacteristic!, type: writeType)
    }
  }
  
  /// Send an array of bytes to the device
  func sendBytesToDevice(_ bytes: [UInt8]) {
    guard isReady else { return }
    
    let data = Data(bytes: UnsafePointer<UInt8>(bytes), count: bytes.count)
    connectedPeripheral!.writeValue(data, for: writeCharacteristic!, type: writeType)
  }
  
  /// Send data to the device
  func sendDataToDevice(_ data: Data) {
    guard isReady else { return }
    
    connectedPeripheral!.writeValue(data, for: writeCharacteristic!, type: writeType)
  }
}


// MARK: - centralManagerStateDescription
extension BluetoothSerial {
  
  var centralManagerStateDescription: String {
    switch centralManager.state {
    case .unknown:
      return "State unknown, update imminent."
      
    case .resetting:
      return "The connection with the system service was momentarily lost, update imminent."
      
    case .unsupported:
      return "The platform doesn't support the Bluetooth Low Energy Central/Client role."
      
    case .unauthorized:
      return "The application is not authorized to use the Bluetooth Low Energy role."
      
    case .poweredOff:
      return "Bluetooth is currently powered off."
      
    case .poweredOn:
      return "Bluetooth is currently powered on and available to use."
    }
  }
  
}


// MARK: - CBCentralManagerDelegate protocol
extension BluetoothSerial: CBCentralManagerDelegate {
  
  func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
    // just send it to the delegate
    delegate.serialDidDiscoverPeripheral?(peripheral, RSSI: RSSI)
  }
  
  func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
    // set some stuff right
    peripheral.delegate = self
    pendingPeripheral = nil
    connectedPeripheral = peripheral
    
    // send it to the delegate
    delegate.serialDidConnect?(peripheral)
    
    // Okay, the peripheral is connected but we're not ready yet!
    // First get the 0xFFE0 service
    // Then get the 0xFFE1 characteristic of this service
    // Subscribe to it & create a weak reference to it (for writing later on),
    // and find out the writeType by looking at characteristic.properties.
    // Only then we're ready for communication
    
    peripheral.discoverServices([serviceUUID])
  }
  
  func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
    connectedPeripheral = nil
    pendingPeripheral = nil
    
    // send it to the delegate
    delegate.serialDidDisconnect(peripheral, error: error as NSError?)
  }
  
  func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
    pendingPeripheral = nil
    
    // just send it to the delegate
    delegate.serialDidFailToConnect?(peripheral, error: error as NSError?)
  }
  
  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    // note that "didDisconnectPeripheral" won't be called if BLE is turned off while connected
    connectedPeripheral = nil
    pendingPeripheral = nil
    
    // send it to the delegate
    delegate.serialDidChangeState()
  }
  
}


// MARK: - CBPeripheralDelegate protocol
extension BluetoothSerial: CBPeripheralDelegate {
  
  func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
    // discover the 0xFFE1 characteristic for all services (though there should only be one)
    for service in peripheral.services! {
      peripheral.discoverCharacteristics([characteristicUUID], for: service)
    }
  }
  
  func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
    // check whether the characteristic we're looking for (0xFFE1) is present - just to be sure
    for characteristic in service.characteristics! {
      if characteristic.uuid == characteristicUUID {
        // subscribe to this value (so we'll get notified when there is serial data for us..)
        peripheral.setNotifyValue(true, for: characteristic)
        
        // keep a reference to this characteristic so we can write to it
        writeCharacteristic = characteristic
        
        // find out writeType
        writeType = characteristic.properties.contains(.write) ? .withResponse : .withoutResponse
        
        // notify the delegate we're ready for communication
        delegate.serialIsReady?(peripheral)
      }
    }
  }
  
  func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
    // notify the delegate in different ways
    // if you don't use one of these, just comment it (for optimum efficiency :])
    guard let data = characteristic.value else { return }
    
    // first the data
    delegate.serialDidReceiveData?(data)
    
    // then the string
    if let str = String(data: data, encoding: String.Encoding.utf8) {
      delegate.serialDidReceiveString?(str)
    } else {
      //print("Received an invalid string!") uncomment for debugging
    }
    
    // now the bytes array
    var bytes = [UInt8](repeating: 0, count: data.count / MemoryLayout<UInt8>.size)
    (data as NSData).getBytes(&bytes, length: data.count)
    delegate.serialDidReceiveBytes?(bytes)
  }
  
  func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
    delegate.serialDidReadRSSI?(RSSI)
  }
  
}
