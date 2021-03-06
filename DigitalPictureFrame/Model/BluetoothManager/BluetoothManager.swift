//
//  BluetoothManager.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//
//

import CoreBluetooth

final class BluetoothManager: NSObject {
  private static var sharedInstance: BluetoothManager!
  
  private var centralManager: CBCentralManager?
  private var connectingTimeoutMonitor: Timer?
  private var interrogatingTimeoutMonitor: Timer?
  private var isConnecting = false
  private(set) var connected = false
  private(set) var connectedPeripheral: CBPeripheral?
  private(set) var connectedServices: [CBService]?
  
  var logs: [String] = []
  var delegate: BluetoothDelegate?
  
  var isReady: Bool {
    return (isConnectedToPeripheral && isPoweredOn)
  }
  
  /// Whether peripheral is ready to send and receive data
  var isConnectedToPeripheral: Bool {
    return connectedPeripheral?.state == .connected ? true : false
  }
  
  var isPoweredOn: Bool {
    return centralManager?.state == .poweredOn
  }
  
  
  static func shared() -> BluetoothManager {
    switch sharedInstance {
    case (nil):
      self.sharedInstance = BluetoothManager()
      return self.sharedInstance
      
    case let (shared?):
      return shared
    }
  }
  
  
  private override init() {
    super.init()
    centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: false])
    BluetoothManager.sharedInstance = self
  }

  
  /**
   The method provides for starting scan near by peripheral
   */
  func startScanPeripheral() {
    centralManager?.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
  }
  
  
  /**
   The method provides for stopping scan near by peripheral
   */
  func stopScanPeripheral() {
    centralManager?.stopScan()
  }
  
  
  /**
   The method provides for connecting the special peripheral
   - parameter peripher: The peripheral you want to connect
   */
  func connectPeripheral(_ peripheral: CBPeripheral) {
    if !isConnecting {
      isConnecting = true
      centralManager?.connect(peripheral, options: [CBConnectPeripheralOptionNotifyOnDisconnectionKey: true])
      connectingTimeoutMonitor = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(self.connectTimeout(_:)), userInfo: peripheral, repeats: false)
    }
  }
  
  
  /**
   The method provides for disconnecting with the peripheral which has connected
   */
  func disconnectPeripheral() {
    if connectedPeripheral != nil {
      centralManager?.cancelPeripheralConnection(connectedPeripheral!)
      startScanPeripheral()
      connectedPeripheral = nil
    } else {
      startScanPeripheral()
      connectedPeripheral = nil
    }
  }
  
  
  /**
   The method provides for the user who want to obtain the descriptor
   - parameter characteristic: The character which user want to obtain descriptor
   */
  func discoverDescriptor(_ characteristic: CBCharacteristic) {
    if connectedPeripheral != nil  {
      connectedPeripheral?.discoverDescriptors(for: characteristic)
    }
  }
  
  
  /**
   The method is invoked when connect peripheral is timeout
   - parameter timer: The timer touch off this selector
   */
  @objc func connectTimeout(_ timer : Timer) {
    guard let connectingPeripheral = timer.userInfo as? CBPeripheral, isConnecting == true else { return }
    
    isConnecting = false
    connectingTimeoutMonitor = nil
    disconnectPeripheral()
    let errorDescription = NSLocalizedString("BLUETOOTH_CONNECTIVITY_ALERT_MESSAGE_CONNECTION_TIMEOUT", comment: "")
    let connectingError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: errorDescription])
    delegate?.didFailToConnectPeripheral?(connectingPeripheral, error: connectingError)
  }
  
  
  /**
   This method is invoked when interrogate peripheral is timeout
   - parameter timer: The timer touch off this selector
   */
  @objc func integrrogateTimeout(_ timer: Timer) {
    disconnectPeripheral()
    delegate?.didFailToInterrogate?((timer.userInfo as! CBPeripheral))
  }
  
  
  /**
   This method provides for discovering the characteristics.
   */
  func discoverCharacteristics() throws {
    guard let connectedPeripheral = connectedPeripheral, isReady else { throw BluetoothError.peripheralNotReady }
    guard let services = connectedPeripheral.services, services.isEmpty == false else { throw BluetoothError.peripheralNoServicesAvailable }
    
    for service in services {
      connectedPeripheral.discoverCharacteristics(nil, for: service)
    }
  }
  
  
  /**
   Read characteristic value from the peripheral
   - parameter characteristic: The characteristic which user should
   */
  func readValueForCharacteristic(characteristic: CBCharacteristic) throws {
    guard let connectedPeripheral = connectedPeripheral, isReady else { throw BluetoothError.peripheralNotReady }
    connectedPeripheral.readValue(for: characteristic)
  }
  
  
  /**
   Start or stop listening for the value update action
   - parameter enable:         If you want to start listening, the value is true, others is false
   - parameter characteristic: The characteristic which provides notifications
   */
  func setNotification(enable: Bool, forCharacteristic characteristic: CBCharacteristic) throws {
    guard let connectedPeripheral = connectedPeripheral, isReady else { throw BluetoothError.peripheralNotReady }
    connectedPeripheral.setNotifyValue(enable, for: characteristic)
  }
  
  
  /**
   Write value to the peripheral which is connected
   - parameter data:           The data which will be written to peripheral
   - parameter characteristic: The characteristic information
   - parameter type:           The write of the operation
   - parameter progressHandler:The closure of progress
   */
  func writeValue(data: Data, forCharacteristic characteristic: CBCharacteristic, writeType: CBCharacteristicWriteType,
                  progressHandler: @escaping (_ bytesSent: Int, _ totalBytesExpectedToSend: Int) -> ()) throws {
    guard let connectedPeripheral = connectedPeripheral, isReady else { throw BluetoothError.peripheralNotReady }

    let fragmentedData = Fragmenter.fragmentise(data: data)
    var writtenDataLength: Int = 0
    
    DispatchQueue.global(qos: .background).async {
      fragmentedData.forEach { fragment in
        connectedPeripheral.writeValue(fragment, for: characteristic, type: writeType)
        
        writtenDataLength = writtenDataLength + fragment.count
        progressHandler(writtenDataLength, Fragmenter.totalSize)
      }
      
      // MARK: Testing
      if let defragmentedData = Defragmenter.defragmentise(data: fragmentedData),
         let stringFromData = String(data: defragmentedData, encoding: String.Encoding.utf8) {
        print(stringFromData)
      }
    }
  }
}


// MARK: - CBPeripheralDelegate protocol
extension BluetoothManager: CBCentralManagerDelegate {
  
  /**
   Invoked whenever the central manager's state has been updated.
   */
  public func centralManagerDidUpdateState(_ central: CBCentralManager) {
    switch central.state {
    case .poweredOff:
      Logger.log(message: "State : Powered Off", event: .debug)
      
    case .poweredOn:
      Logger.log(message: "State : Powered On", event: .debug)
      
    case .resetting:
      Logger.log(message: "State : Resetting", event: .debug)
      
    case .unauthorized:
      Logger.log(message: "State : Unauthorized", event: .debug)
      
    case .unknown:
      Logger.log(message: "State : Unknown", event: .debug)
      
    case .unsupported:
      Logger.log(message: "State : Unsupported", event: .debug)
    }
    
    delegate?.didUpdateState?(central.state)
  }
  
  
  /**
   This method is invoked while scanning, upon the discovery of peripheral by central
   - parameter central:           The central manager providing this update.
   - parameter peripheral:        The discovered peripheral.
   - parameter advertisementData: A dictionary containing any advertisement and scan response data.
   - parameter RSSI:              The current RSSI of peripheral, in dBm. A value of 127 is reserved and indicates the RSSI
   *                was not available.
   */
  public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
//    let message = "Bluetooth Manager --> didDiscoverPeripheral, RSSI:\(RSSI)"
//    Logger.log(message: message, event: .debug)
    delegate?.didDiscoverPeripheral?(peripheral, advertisementData: advertisementData, RSSI: RSSI)
  }
  
  
  /**
   This method is invoked when a connection succeeded
   - parameter central:    The central manager providing this information.
   - parameter peripheral: The peripheral that has connected.
   */
  public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
    let message = "Bluetooth Manager --> didConnectPeripheral"
    Logger.log(message: message, event: .debug)
    
    isConnecting = false
    if connectingTimeoutMonitor != nil {
      connectingTimeoutMonitor!.invalidate()
      connectingTimeoutMonitor = nil
    }
    
    connected = true
    connectedPeripheral = peripheral
    delegate?.didConnectedPeripheral?(peripheral)
    stopScanPeripheral()
    peripheral.delegate = self
    peripheral.discoverServices(nil)
    interrogatingTimeoutMonitor = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.integrrogateTimeout(_:)), userInfo: peripheral, repeats: false)
  }
  
  
  /**
   This method is invoked where a connection failed.
   - parameter central:    The central manager providing this information.
   - parameter peripheral: The peripheral that you tried to connect.
   - parameter error:      The error infomation about connecting failed.
   */
  public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
    let message = "Bluetooth Manager --> didFailToConnectPeripheral"
    Logger.log(message: message, event: .debug)
    
    isConnecting = false
    if connectingTimeoutMonitor != nil {
      connectingTimeoutMonitor!.invalidate()
      connectingTimeoutMonitor = nil
    }
    connected = false
    delegate?.didFailToConnectPeripheral?(peripheral, error: error!)
  }
  
  
  /**
   This method is invoked when the peripheral has been disconnected.
   - parameter central:    The central manager providing this information
   - parameter peripheral: The disconnected peripheral
   - parameter error:      The error message
   */
  public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
    let message = "Bluetooth Manager --> didDisconnectPeripheral"
    Logger.log(message: message, event: .debug)
    
    connected = false
    self.delegate?.didDisconnectPeripheral?(peripheral)
    NotificationCenter.default.post(name: NotificationName.peripheralDisconnectNotification.name, object: self)
  }
  
}



// MARK: - CBPeripheralDelegate protocol
extension BluetoothManager: CBPeripheralDelegate {
  
  /**
   This method is invoked when the peripheral has found the descriptor for the characteristic
   - parameter peripheral:     The peripheral providing this information
   - parameter characteristic: The characteristic which has the descriptor
   - parameter error:          The error message
   */
  public func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
    let message = "Bluetooth Manager --> didDiscoverDescriptorsForCharacteristic"
    Logger.log(message: message, event: .debug)
    
    if error != nil {
      let message = "Bluetooth Manager --> Fail to discover descriptor for characteristic Error:\(String(describing: error?.localizedDescription))"
      Logger.log(message: message, event: .debug)
      Logger.logInfo(message: message)
      
      delegate?.didFailToDiscoverDescriptors?(error!)
      return
    }
    delegate?.didDiscoverDescriptors?(characteristic)
  }
  
  
  /**
   Thie method is invoked when the user call the peripheral.readValueForCharacteristic
   - parameter peripheral:     The periphreal which call the method
   - parameter characteristic: The characteristic with the new value
   - parameter error:          The error message
   */
  public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
    let message = "Bluetooth Manager --> didUpdateValueForCharacteristic"
    Logger.log(message: message, event: .debug)
    
    if error != nil {
      let message = "Bluetooth Manager --> Failed to read value for the characteristic. Error:\(error!.localizedDescription)"
      Logger.log(message: message, event: .debug)
      Logger.logInfo(message: message)
      
      delegate?.didFailToReadValueForCharacteristic?(error!)
      return
    }
    delegate?.didReadValueForCharacteristic?(characteristic)
    
  }

  
  /**
   The method is invoked where services were discovered.
   - parameter peripheral: The peripheral with service informations.
   - parameter error:      Errot message when discovered services.
   */
  public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
    let message = "Bluetooth Manager --> didDiscoverServices"
    Logger.log(message: message, event: .debug)
    
    connectedPeripheral = peripheral
    if error != nil {
      let message = "Bluetooth Manager --> Discover Services Error, error:\(String(describing: error?.localizedDescription))"
      Logger.log(message: message, event: .debug)
      Logger.logInfo(message: message)
      return
    }
    
    // If discover services, then invalidate the timeout monitor
    if interrogatingTimeoutMonitor != nil {
      interrogatingTimeoutMonitor?.invalidate()
      interrogatingTimeoutMonitor = nil
    }
    
    self.delegate?.didDiscoverServices?(peripheral)
  }
  
  
  /**
   The method is invoked where characteristics were discovered.
   - parameter peripheral: The peripheral provide this information
   - parameter service:    The service included the characteristics.
   - parameter error:      If an error occurred, the cause of the failure.
   */
  public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
    let message = "Bluetooth Manager --> didDiscoverCharacteristicsForService"
    Logger.log(message: message, event: .debug)
    
    if error != nil {
      let message = "Bluetooth Manager --> Fail to discover characteristics! Error: \(String(describing: error?.localizedDescription))"
      Logger.log(message: message, event: .debug)
      Logger.logInfo(message: message)
      
      delegate?.didFailToDiscoverCharacteritics?(error!)
      return
    }
    
    delegate?.didDiscoverCharacteritics?(service)
  }
  
}


// MARK: - centralManagerStateDescription
extension BluetoothManager {
  
  var stateDescription: String {
    switch centralManager?.state {
    case .unknown?:
      return "State unknown, update imminent."
      
    case .resetting?:
      return "The connection with the system service was momentarily lost, update imminent."
      
    case .unsupported?:
      return "The platform doesn't support the Bluetooth Low Energy Central/Client role."
      
    case .unauthorized?:
      return "The application is not authorized to use the Bluetooth Low Energy role."
      
    case .poweredOff?:
      return "Bluetooth is currently powered off."
      
    case .poweredOn?:
      return "Bluetooth is currently powered on and available to use."
      
    default:
      return "State unknown, update imminent."
    }
  }
  
}
