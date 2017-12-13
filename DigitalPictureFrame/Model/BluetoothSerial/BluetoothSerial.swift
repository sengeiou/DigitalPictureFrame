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
  
  // First up, check if we're meant to be sending an EOM
  private var isSendingEOM = false
  private var writeDataLength: Int = 0
  private var maximumWriteLength: Int = 0
  private var writtenData: Data = Data()
  
  
  
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
      centralManager.cancelPeripheralConnection(pendingPeripheral)
    }
  }

}


// MARK: - Clean up
private extension BluetoothSerial {
  /** Call this when things either go wrong, or you're done with the connection.
   *  This cancels any subscriptions if there are any, or straight disconnects if not.
   *  (didUpdateNotificationStateForCharacteristic will cancel the connection if a subscription is involved)
   */
  func cleanup() {
    guard connectedPeripheral?.state == .connected else { return }
    
    // See if we are subscribed to a characteristic on the peripheral
    guard let services = connectedPeripheral?.services else {
      disconnect()
      return
    }
    
    for service in services {
      guard let characteristics = service.characteristics else { continue }
      
      for characteristic in characteristics {
        if characteristic.uuid.isEqual(characteristicUUID) && characteristic.isNotifying {
          connectedPeripheral?.setNotifyValue(false, for: characteristic)
          return
        }
      }
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

    if isSendingEOM {
      // send it again
      connectedPeripheral.writeValue("EOM".data(using: String.Encoding.utf8)!, for: writeCharacteristic!, type: writeType)
      isSendingEOM = false
      return
    }

    // There's data left, so send until the callback fails, or we're done.
    maximumWriteLength = connectedPeripheral.maximumWriteValueLength(for: writeType)
    while isSendingEOM == false {
      var amountToSend = data.count - writeDataLength;
      
      // Can't be longer than 512 bytes
      if (amountToSend > maximumWriteLength) {
        amountToSend = maximumWriteLength
      }
      
      // Copy out the data we want
      let chunk: Data = data.withUnsafeBytes {(body: UnsafePointer<UInt8>) in
        return Data(bytes: body + writeDataLength, count: amountToSend)
      }
      
      // Send chunk
      connectedPeripheral.writeValue(chunk, for: writeCharacteristic!, type: writeType)
//      let stringFromData = NSString(data: chunk, encoding: String.Encoding.utf8.rawValue)
//      print("Sent: \(String(describing: stringFromData))")
      
      // It did send, so update our index
      writeDataLength += amountToSend;
      delegate.serialDidSendBytes?(chunk: writeDataLength, of: data.count)
      // Was it the last one?
      if (writeDataLength >= data.count) {
        // Send End Of Message
        connectedPeripheral.writeValue("EOM".data(using: String.Encoding.utf8)!, for: writeCharacteristic!, type: writeType)
        isSendingEOM = true
        return
      }
    }
  }
  
  
  /// The didReadRSSI delegate function will be called after calling this function
  func readRSSI() {
    guard let connectedPeripheral = connectedPeripheral, isReady else { return }
    connectedPeripheral.readRSSI()
  }
  
}


// MARK: - CBCentralManagerDelegate protocol
extension BluetoothSerial: CBCentralManagerDelegate {
  
  func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
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
    writeDataLength = 0
    delegate.serialDidChangeState()
  }

}


// MARK: - CBPeripheralDelegate protocol
extension BluetoothSerial: CBPeripheralDelegate {
  
  /** The Transfer Service was discovered
   */
  func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
    guard error == nil else {
      print("Error discovering services: \(error!.localizedDescription)")
      cleanup()
      return
    }
    
    guard let services = peripheral.services else { return }
    
    // discover the 0xFFE1 characteristic for all services (though there should only be one)
    for service in services {
      peripheral.discoverCharacteristics([characteristicUUID], for: service)
    }
  }
  
  
  /** The Transfer characteristic was discovered.
   *  Once this has been found, we want to subscribe to it, which lets the peripheral know we want the data it contains
   */
  func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
    guard error == nil else {
      print("Error discovering services: \(error!.localizedDescription)")
      cleanup()
      return
    }
    
    guard let characteristics = service.characteristics else { return }
    
    // check whether the characteristic we're looking for (0xFFE1) is present - just to be sure
    for characteristic in characteristics {
      if characteristic.uuid.isEqual(characteristicUUID) {
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
  
  
  /** Invoked when you write data to a characteristic’s value.
   */
  func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
    guard error == nil else {
      print("Error discovering services: \(error!.localizedDescription)")
      return
    }
    
    guard let characteristicValue = characteristic.value else { return }
    guard let stringFromData = NSString(data: characteristicValue, encoding: String.Encoding.utf8.rawValue) else {
      print("Invalid data")
      return
    }
    
    // Have we got everything we need?
    if stringFromData.isEqual(to: "EOM") {
      delegate.serialDidReceiveString?(stringFromData as String)
      delegate.serialDidReceiveData?(writtenData)
      
      // Cancel our subscription to the characteristic
      peripheral.setNotifyValue(false, for: characteristic)
      // and disconnect from the peripehral
      centralManager.cancelPeripheralConnection(peripheral)
    } else {
      // Otherwise, just add the data on to what we already have
      writtenData.append(characteristicValue)
      
      // Log it
      //      print("didUpdateValueFor Received: \(stringFromData)")
    }
  }
  

  /** Invoked after you call readRSSI() to retrieve the value of the peripheral’s current RSSI while it is connected to the central manager.
   */
  func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
    delegate.serialDidReadRSSI?(RSSI)
  }
  
  
  /** The peripheral letting us know whether our subscribe/unsubscribe happened or not
   */
  func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
    print("Error changing notification state: \(String(describing: error?.localizedDescription))")
    
    // Exit if it's not the transfer characteristic
    guard characteristic.uuid.isEqual(characteristicUUID) else { return }
    
    // Notification has started
    if (characteristic.isNotifying) {
      print("Notification began on \(characteristic)")
      
    } else { // Notification has stopped
      print("Notification stopped on (\(characteristic)) Disconnecting")
      centralManager.cancelPeripheralConnection(peripheral)
    }
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
