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
  @IBOutlet weak var searchDevicesButton: UIButton!
  @IBOutlet weak var sendJSONFileButton: UIButton!
  
  lazy private var scanningIndicator: NVActivityIndicatorView = {
    let tableViewSize = self.tableView.frame.size
    let size = CGSize(width: 200, height: 200)
    let originPoint = CGPoint(x: (tableViewSize.width / 2) - (size.width / 2), y: (tableViewSize.height / 2) - (size.height / 2))
    let frame = CGRect(origin: originPoint, size: size)
    let indicator = NVActivityIndicatorView(frame: frame, type: .ballScaleRippleMultiple, color: UIColor.appleBlue)
    self.tableView.addSubview(indicator)
    return indicator
  }()
  
  var sharedInstance = BluetoothSerialSingleton.sharedInstance
  private var dataSourceDelegate: BluetoothConnectivityDataSourceDelegate?
  
  var selectedPeripheral: CBPeripheral?
  var peripherals: [PeripheralItem] = [] {
    didSet {
      // TODO:
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
  
  
  func startScanningIndicatorAnimating() {
    
    scanningIndicator.startAnimating()
  }
  
  func stopScanningIndicatorAnimating() {
    scanningIndicator.stopAnimating()
  }
}


// MARK: - ViewSetupable protocol
extension BluetoothConnectivityViewController: ViewSetupable {
  
  func setup() {
    peripherals = [PeripheralItem(name: "Test", RSSI: 12.3),
                   PeripheralItem(name: "Test2", RSSI: 12.3),
                   PeripheralItem(name: "Test3", RSSI: 12.3),
                   PeripheralItem(name: "Test4", RSSI: 12.3)]
    
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
    BluetoothStyle.roundCorners(for: searchDevicesButton, sendJSONFileButton)
    reloadView()
  }
  
}


// MARK: - Reload view
extension BluetoothConnectivityViewController {
  
  func reloadView() {
    renderSerialConnectionStateTitle()
    
    if sharedInstance.serial.isReady {
      connectedPeripheralLabel.text = sharedInstance.serial.connectedPeripheral!.name
      searchDevicesButton.setTitle("Disconnect", for: .normal)
      searchDevicesButton.tintColor = UIColor.red
      searchDevicesButton.isEnabled = true
      
      sendJSONFileButton.setTitle("Send JSON", for: .normal)
      sendJSONFileButton.isEnabled = true
      
    } else if sharedInstance.serial.centralManager.state == .poweredOn {
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
  
  
  func renderSerialConnectionStateTitle() {
    centralManagerStateLabel.text = sharedInstance.serial.centralManagerStateDescription
  }
  
}


// Show/Hide No data available message
private extension BluetoothConnectivityViewController {
  
  var isAvailableMessageVisible: Bool {
    if let _ = tableView.viewWithTag(EmbeddedViewTag.availabilityMessage.rawValue) {
      return true
    }
    
    return false
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
    tableView.tableFooterView = UIView()
  }
  
}



// MARK: - BluetoothSerialDelegate protocol
extension BluetoothConnectivityViewController: BluetoothSerialDelegate {
  
  func serialDidReceiveData(_ data: Data) {
    print("serialDidReceiveData")
    MBProgressHUD.showHUD(in: view, with: "Peripheral did receive data")
  }
  
  func serialDidDisconnect(_ peripheral: CBPeripheral, error: NSError?) {
    print("serialDidDisconnect")
    reloadView()
    MBProgressHUD.showHUD(in: view, with: "Disconnected")
  }
  
  func serialIsReady(_ peripheral: CBPeripheral) {
    print("serialIsReady")
    MBProgressHUD.showHUD(in: view, with: "Peripheral is ready for communication")
    /// Called when a peripheral is ready for communication
  }
  
  func serialDidChangeState() {
    print("serialDidChangeState")
    reloadView()
    if sharedInstance.serial.centralManager.state != .poweredOn {
      MBProgressHUD.showHUD(in: view, with: "Bluetooth turned off")
    }
  }
  
}


// MARK: - BluetoothScanningCellDelegate protocol
extension BluetoothConnectivityViewController: BluetoothScanningCellDelegate {
  
  func bluetoothScanningCell(_ bluetoothScanningCell: BluetoothScanningTableViewCell, didConnectPeripheral at: Int) {
    print("didConnectPeripheral")
  }
  
}
