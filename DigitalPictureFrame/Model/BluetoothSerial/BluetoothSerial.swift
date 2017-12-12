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
  /// The CBCentralManager this bluetooth serial handler uses for... well, everything really
  private var centralManager: CBCentralManager!
  
  /// UUID of the service to look for.
  private var serviceUUID = CBUUID(string: "EC00")
//  private var serviceUUID = CBUUID(string: "FFE0")
  
  /// UUID of the characteristic to look for. ec0e
  private var characteristicUUID = CBUUID(string: "EC0E")
//  private var characteristicUUID = CBUUID(string: "FFE1")
  
  /// The connected peripheral
  private var connectedPeripheral: CBPeripheral?
  
  /// The peripheral we're trying to connect to
  private var pendingPeripheral: CBPeripheral?
  
  /// Whether to write to the HM10 with or without response. Set automatically.
  /// Legit HM10 modules (from JNHuaMao) require 'Write without Response',
  /// while fake modules (e.g. from Bolutek) require 'Write with Response'.
  private var writeType: CBCharacteristicWriteType = .withoutResponse

  /// The characteristic 0xFFE1 we need to write to, of the connectedPeripheral
  weak var writeCharacteristic: CBCharacteristic?
  var delegate: BluetoothSerialDelegate!
  
  /// Whether this serial is ready to send and receive data
  var isReady: Bool {
    return centralManager.state == .poweredOn && connectedPeripheral != nil && writeCharacteristic != nil
  }
  
  var isScanning: Bool {
    return centralManager.isScanning
  }
  
  var isPoweredOn: Bool {
    return centralManager.state == .poweredOn
  }
  
  var isConnectedToPeripheral: Bool {
    return connectedPeripheral == nil ? false : true
  }
  
  var connectedPeripheralName: String {
    return connectedPeripheral?.name ?? "Not available"
  }
  
  
  init(delegate: BluetoothSerialDelegate) {
    super.init()
    self.delegate = delegate
    centralManager = CBCentralManager(delegate: self, queue: nil)
  }
}


// MARK: - Start/Stop scanning
extension BluetoothSerial {
  
  func startScan() {
    guard centralManager.state == .poweredOn else { return }
    
    // start scanning for peripherals with correct service UUID
    centralManager.scanForPeripherals(withServices: [serviceUUID], options: nil)
    
    // retrieve peripherals that are already connected
    let peripherals = centralManager.retrieveConnectedPeripherals(withServices: [serviceUUID])
    for peripheral in peripherals {
      delegate.serialDidDiscoverPeripheral?(peripheral, RSSI: nil)
    }
  }
  

  func stopScan() {
    centralManager.stopScan()
  }
  
}


// MARK: - Connect/Disconnect from peripheral
extension BluetoothSerial {
  
  func connectToPeripheral(_ peripheral: CBPeripheral) {
    pendingPeripheral = peripheral
    centralManager.connect(peripheral, options: nil)
  }
  
  func disconnect() {
    if let connectedPeripheral = connectedPeripheral {
      centralManager.cancelPeripheralConnection(connectedPeripheral)
      
    } else if let pendingPeripheral = pendingPeripheral {
      centralManager.cancelPeripheralConnection(pendingPeripheral) //TODO: Test whether its neccesary to set p to nil
    }
  }
  
}


// MARK: - Send data to device
extension BluetoothSerial {
  
  func sendMessageToDevice(_ message: String) {
    guard let connectedPeripheral = connectedPeripheral, isReady else { return }
    
    if let data = message.data(using: String.Encoding.utf8) {
      connectedPeripheral.writeValue(data, for: writeCharacteristic!, type: writeType)
    }
  }
  
  
  func sendBytesToDevice(_ bytes: [UInt8]) {
    guard let connectedPeripheral = connectedPeripheral, isReady else { return }
    
    let data = Data(bytes: UnsafePointer<UInt8>(bytes), count: bytes.count)
    connectedPeripheral.writeValue(data, for: writeCharacteristic!, type: writeType)
  }
  
  
  func sendDataToDevice(_ data: Data) {
    guard let connectedPeripheral = connectedPeripheral, isReady else { return }
    
    connectedPeripheral.writeValue(data, for: writeCharacteristic!, type: writeType)
  }
  
  
  /// The didReadRSSI delegate function will be called after calling this function
  func readRSSI() {
    guard let connectedPeripheral = connectedPeripheral, isReady else { return }
    connectedPeripheral.readRSSI()
  }
  
}

// MARK: - centralManagerStateDescription
extension BluetoothSerial {
  
  var stateDescription: String {
    
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
    peripheral.delegate = self
    pendingPeripheral = nil
    connectedPeripheral = peripheral
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
    delegate.serialDidDisconnect(peripheral, error: error as NSError?)
  }
  
  
  func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
    pendingPeripheral = nil
    delegate.serialDidFailToConnect?(peripheral, error: error as NSError?)
  }
  
  
  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    // note that "didDisconnectPeripheral" won't be called if BLE is turned off while connected
    connectedPeripheral = nil
    pendingPeripheral = nil
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
    guard let data = characteristic.value else { return }
    
    delegate.serialDidReceiveData?(data)
    
    if let str = String(data: data, encoding: String.Encoding.utf8) {
      delegate.serialDidReceiveString?(str)
    } else {
      print("Received an invalid string!") //uncomment for debugging
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
