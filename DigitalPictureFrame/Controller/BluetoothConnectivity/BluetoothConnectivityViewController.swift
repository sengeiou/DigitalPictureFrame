//
//  BluetoothConnectivityViewController.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit
import CoreBluetooth
import NVActivityIndicatorView
import MBProgressHUD

class BluetoothConnectivityViewController: UIViewController {
  @IBOutlet weak var connectedPeripheralLabel: UILabel!
  @IBOutlet weak var centralManagerStateLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchDevicesButton: ShadowButton!
  @IBOutlet weak var sendJSONFileButton: ShadowButton!
  
  lazy private var scanningIndicator: NVActivityIndicatorView = {
    let tableViewSize = self.tableView.frame.size
    let size = CGSize(width: 210, height: 210)
    let originPoint = CGPoint(x: (tableViewSize.width / 2) - (size.width / 2), y: (tableViewSize.height / 2) - (size.height / 2))
    let frame = CGRect(origin: originPoint, size: size)
    let indicator = NVActivityIndicatorView(frame: frame, type: .ballScaleRippleMultiple, color: UIColor.appleBlue)
    self.tableView.addSubview(indicator)
    return indicator
  }()
  
  private var dataSourceDelegate: BluetoothConnectivityDataSourceDelegate?
  var sharedInstance = BluetoothSerialSingleton.sharedInstance
  var selectedPeripheral: CBPeripheral?
  var peripherals: [PeripheralItem] = [] {
    didSet {
      dataSourceDelegate?.items = peripherals
    }
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupStyle()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setupLayout()
  }
  
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

  }
}


// MARK: - ViewSetupable protocol
extension BluetoothConnectivityViewController: ViewSetupable {
  
  func setup() {
    // MARK: - TEST CASE!
//    peripherals = [PeripheralItem(RSSI: 12.3), PeripheralItem(RSSI: 12.3), PeripheralItem(RSSI: 12.3), PeripheralItem(RSSI: 12.3)]
    
    sharedInstance.serial = BluetoothSerial(delegate: self)
    dataSourceDelegate = BluetoothConnectivityDataSource(self, items: peripherals)
    
    tableView.register(cell: BluetoothScanningTableViewCell.self)
    tableView.dataSource = dataSourceDelegate
    tableView.delegate = dataSourceDelegate
    tableView.isScrollEnabled = false
    tableView.tableFooterView = UIView(frame: .zero)
  }

  
  func setupStyle() {
    typealias BluetoothStyle = Style.BluetoothConnectivityVC
  
    searchDevicesButton.titleLabel?.font = BluetoothStyle.buttonTitleFont
    sendJSONFileButton.titleLabel?.font = BluetoothStyle.buttonTitleFont
    reloadView()
  }
  
  
  func setupLayout() {
    renderNoPeripheralsAvailableMessage()
  }
}


// MARK: - Reload view
extension BluetoothConnectivityViewController {
  
  func reloadView() {
    renderSerialConnectionStateTitle()
    renderButtonsTitle()
  }
  
  func clearPeripherals() {
    peripherals = []
    tableView.reloadData()
  }
}


// MARK: - Render titles
private extension BluetoothConnectivityViewController {
  
  func renderSerialConnectionStateTitle() {
    centralManagerStateLabel.text = sharedInstance.serial.stateDescription
  }
  
  func renderButtonsTitle() {
    if sharedInstance.serial.isReady {
      connectedPeripheralLabel.text = sharedInstance.serial.connectedPeripheralName
      searchDevicesButton.setTitle("Disconnect", for: .normal)
      searchDevicesButton.tintColor = UIColor.red
      searchDevicesButton.isEnabled = true
      
      sendJSONFileButton.setTitle("Send JSON", for: .normal)
      sendJSONFileButton.isEnabled = true
      
    } else if sharedInstance.serial.isPoweredOn {
      connectedPeripheralLabel.text = "Bluetooth Serial"
      searchDevicesButton.setTitle("Scan", for: .normal)
      searchDevicesButton.tintColor = view.tintColor
      searchDevicesButton.isEnabled = true
      
      sendJSONFileButton.setTitle("Send JSON", for: .normal)
      sendJSONFileButton.isEnabled = false
      
    } else {
      connectedPeripheralLabel.text = "Bluetooth Serial"
      searchDevicesButton.setTitle("Scan", for: .normal)
      searchDevicesButton.tintColor = view.tintColor
      searchDevicesButton.isEnabled = false
      
      sendJSONFileButton.setTitle("Send JSON", for: .normal)
      sendJSONFileButton.isEnabled = false
    }
  }
  
}


// Show/Hide No data available message
extension BluetoothConnectivityViewController {
  
  var isAvailableMessageVisible: Bool {
    if let _ = tableView.viewWithTag(EmbeddedViewTag.availabilityMessage.rawValue) {
      return true
    }
    
    return false
  }
  
  var shouldShowAvailableMessage: Bool {
    return dataSourceDelegate?.numberOfRowsInSection == 0 ? true : false
  }
  
  
  func showNoPeripheralsAvailableMessage() {
    guard !isAvailableMessageVisible else { return }
    removeTableViewEmptyCells()
    
    let messageHeight = CGFloat(25)
    let xPos = CGFloat(0)
    let yPos = (tableView.frame.size.height - (messageHeight * 2)) / 2
    let width = tableView.frame.size.width
    let titleMessage = "No peripherals available"
    let subtitleMessage = "Scan again"
    
    let frame = CGRect(x: xPos, y: yPos, width: width, height: messageHeight * 2)
    let availabilityMessage = AvailabilityMessageView(frame: frame, titles: titleMessage, subtitleMessage)
    tableView.addSubview(availabilityMessage)
  }
  
  
  func hideNoPeripheralsAvailableMessage() {
    guard isAvailableMessageVisible else { return }
    let availabilityMessageView = tableView.viewWithTag(EmbeddedViewTag.availabilityMessage.rawValue)
    availabilityMessageView?.removeFromSuperview()
  }
  
  
  func removeTableViewEmptyCells() {
    tableView.tableFooterView = UIView(frame: .zero)
  }
  
  
  func renderNoPeripheralsAvailableMessage() {
    shouldShowAvailableMessage ? showNoPeripheralsAvailableMessage() : hideNoPeripheralsAvailableMessage()
  }
}


// MARK: - Start/Stop scanning animation
extension BluetoothConnectivityViewController {
  
  func startScanningIndicator() {
    scanningIndicator.startAnimating()
  }
  
  func stopScanningIndicator() {
    scanningIndicator.stopAnimating()
  }
}


// MARK: - BluetoothSerialDelegate protocol
extension BluetoothConnectivityViewController: BluetoothSerialDelegate {
  
//  func fakeSerialDidDiscoverPeripheral(_ peripheral: PeripheralItem, RSSI: NSNumber?) {
//    print("serialDidDiscoverPeripheral: \(String(describing: peripheral.name))")
//    let foundPeripheral = peripheral
//    peripherals.append(foundPeripheral)
//    peripherals.sort { $0.RSSI < $1.RSSI }
//  }
  
    
  func serialDidDiscoverPeripheral(_ peripheral: CBPeripheral, RSSI: NSNumber?) {
    print("serialDidDiscoverPeripheral: \(String(describing: peripheral.name))")
    
    for exisiting in peripherals {
      if exisiting.peripheral?.identifier == peripheral.identifier { return }
    }
    
    let theRSSI = RSSI?.floatValue ?? 0.0
    let foundPeripheral = PeripheralItem(peripheral: peripheral, RSSI: theRSSI)
    peripherals.append(foundPeripheral)
    peripherals.sort { $0.RSSI < $1.RSSI }
  }
  
  
  func serialDidFailToConnect(_ peripheral: CBPeripheral, error: NSError?) {
    searchDevicesButton.isEnabled = true
    MBProgressHUD.showHUD(in: view, with: "Failed to connect")
  }

  
  func serialDidReceiveData(_ data: Data) {
    MBProgressHUD.showHUD(in: view, with: "Peripheral did receive data")
  }
  
  
  func serialDidConnect(_ peripheral: CBPeripheral) {
    sendJSONFileButton.isEnabled = true
    MBProgressHUD.showHUD(in: view, with: "Connected")
  }
  
  
  func serialDidDisconnect(_ peripheral: CBPeripheral, error: NSError?) {
    reloadView()
    MBProgressHUD.showHUD(in: view, with: "Disconnected")
  }
  
  func serialIsReady(_ peripheral: CBPeripheral) {
    MBProgressHUD.showHUD(in: view, with: "Peripheral is ready for communication")
  }
  
  func serialDidChangeState() {
    print("serialDidChangeState")
    reloadView()
    if !sharedInstance.serial.isPoweredOn {
      MBProgressHUD.showHUD(in: view, with: "Bluetooth turned off")
    }
  }
  
}


// MARK: - BluetoothScanningCellDelegate protocol
extension BluetoothConnectivityViewController: BluetoothScanningCellDelegate {
  
  func bluetoothScanningCell(_ bluetoothScanningCell: BluetoothScanningTableViewCell, didPressConnect button: UIButton) {
    print("didPressConnect at row: \(button.tag)")
    sharedInstance.serial.stopScan()
    
    let row = button.tag
    guard let selectedPeripheral = peripherals[row].peripheral else { return }
    sharedInstance.serial.connectToPeripheral(selectedPeripheral)
    MBProgressHUD.showHUD(in: view, with: "Connecting")
    scheduleTimerForConnectTimeOut()
  }
  
  
  @objc func connectTimeOut() {
    guard !sharedInstance.serial.isConnectedToPeripheral else { return }
    
    if let _ = selectedPeripheral {
      sharedInstance.serial.disconnect()
      selectedPeripheral = nil
    }
    
    MBProgressHUD.showHUD(in: view, with: "Failed to connect")
  }
  
  
  @objc func scanTimeOut() {
    sharedInstance.serial.stopScan()
    searchDevicesButton.isEnabled = true
    connectedPeripheralLabel.text = "Done scanning"
    stopScanningIndicator()
    renderNoPeripheralsAvailableMessage()
    tableView.reloadData()
  }
  
}


// MARK: - Schedule Timer
extension BluetoothConnectivityViewController {
  
  func scheduleTimerForScanTimeOut() {
    Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(BluetoothConnectivityViewController.scanTimeOut),
                         userInfo: nil, repeats: false)
  }
  
  func scheduleTimerForConnectTimeOut() {
    Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(BluetoothConnectivityViewController.connectTimeOut),
                         userInfo: nil, repeats: false)
  }
}



//// MARK: - Reload Rows
//extension BluetoothConnectivityViewController {
//
//  func registerNotification() {
//    addReloadDataNofificationObserver()
//  }
//
//  func unregisterNotification() {
//    removeReloadDataNofificationObserver()
//  }
//
//
//  func addReloadDataNofificationObserver() {
//    NotificationCenter.default.addObserver(self, selector: #selector(BluetoothConnectivityViewController.reloadData),
//                                           name: NotificationName.reloadData.name, object: nil)
//  }
//
//  func removeReloadDataNofificationObserver() {
//    NotificationCenter.default.removeObserver(self, name: NotificationName.reloadData.name, object: nil)
//  }
//
//  @objc func reloadData() {
//
//  }
//}

