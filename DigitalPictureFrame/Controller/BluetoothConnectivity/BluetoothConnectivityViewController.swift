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
  @IBOutlet weak var connectivityTitleLabel: UILabel!
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
    
    connectivityTitleLabel.font = BluetoothStyle.connectivityTitleLabelFont
    connectivityTitleLabel.numberOfLines = BluetoothStyle.connectivityTitleLabelNumberOfLines
    connectivityTitleLabel.textAlignment = BluetoothStyle.connectivityTitleLabelAlignment
    
    centralManagerStateLabel.font = BluetoothStyle.centralManagerStateLabelFont
    centralManagerStateLabel.numberOfLines = BluetoothStyle.centralManagerStateLabelNumberOfLines
    centralManagerStateLabel.textAlignment = BluetoothStyle.centralManagerStateLabelAlignment
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
      connectivityTitleLabel.text = sharedInstance.serial.connectedPeripheralName
      searchDevicesButton.setTitle(NSLocalizedString("BLUETOOTH_CONNECTIVITY_BUTTON_DISCONNECT_TITLE", comment: ""), for: .normal)
      searchDevicesButton.tintColor = .red
      searchDevicesButton.isEnabled = true
      
      sendJSONFileButton.setTitle(NSLocalizedString("BLUETOOTH_CONNECTIVITY_BUTTON_SCAN_TITLE", comment: ""), for: .normal)
      sendJSONFileButton.isEnabled = true
      
    } else if sharedInstance.serial.isPoweredOn {
      connectivityTitleLabel.text = NSLocalizedString("BLUETOOTH_CONNECTIVITY_LABEL_TITLE", comment: "")
      searchDevicesButton.setTitle(NSLocalizedString("BLUETOOTH_CONNECTIVITY_BUTTON_SCAN_TITLE", comment: ""), for: .normal)
      searchDevicesButton.tintColor = view.tintColor
      searchDevicesButton.isEnabled = true
      
      sendJSONFileButton.setTitle(NSLocalizedString("BLUETOOTH_CONNECTIVITY_BUTTON_SEND_TITLE", comment: ""), for: .normal)
      sendJSONFileButton.isEnabled = false
      
    } else {
      connectivityTitleLabel.text = NSLocalizedString("BLUETOOTH_CONNECTIVITY_LABEL_TITLE", comment: "")
      searchDevicesButton.setTitle(NSLocalizedString("BLUETOOTH_CONNECTIVITY_BUTTON_SCAN_TITLE", comment: ""), for: .normal)
      searchDevicesButton.tintColor = view.tintColor
      searchDevicesButton.isEnabled = false
      
      sendJSONFileButton.setTitle(NSLocalizedString("BLUETOOTH_CONNECTIVITY_BUTTON_SEND_TITLE", comment: ""), for: .normal)
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
    let titleMessage = NSLocalizedString("BLUETOOTH_CONNECTIVITY_LABEL_NO_PERIPHERALS_AVAILABLE_TITLE", comment: "")
    let subtitleMessage = NSLocalizedString("BLUETOOTH_CONNECTIVITY_LABEL_NO_PERIPHERALS_AVAILABLE_SUBTITLE", comment: "")
    
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
    print("serialDidDiscoverPeripheral: \(String(describing: peripheral.name))")  // TODO: TEST REMOVE!
    
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
    MBProgressHUD.showHUD(in: view, with: NSLocalizedString("BLUETOOTH_CONNECTIVITY_PROGRESS_HUD_MSG_FAILED_TO_CONNECT", comment: ""))
  }

  
  func serialDidReceiveData(_ data: Data) {
    MBProgressHUD.showHUD(in: view, with: NSLocalizedString("BLUETOOTH_CONNECTIVITY_PROGRESS_HUD_MSG_PERIPHERAL_RECEIVED_DATA", comment: ""))
  }
  
  
  func serialDidConnect(_ peripheral: CBPeripheral) {
    sendJSONFileButton.isEnabled = true
    MBProgressHUD.showHUD(in: view, with: NSLocalizedString("BLUETOOTH_CONNECTIVITY_PROGRESS_HUD_MSG_CONNECTED", comment: ""))
  }
  
  
  func serialDidDisconnect(_ peripheral: CBPeripheral, error: NSError?) {
    reloadView()
    MBProgressHUD.showHUD(in: view, with: NSLocalizedString("BLUETOOTH_CONNECTIVITY_PROGRESS_HUD_MSG_DISCONNECTED", comment: ""))
  }
  
  func serialIsReady(_ peripheral: CBPeripheral) {
    MBProgressHUD.showHUD(in: view, with: NSLocalizedString("BLUETOOTH_CONNECTIVITY_PROGRESS_HUD_MSG_READY", comment: ""))
  }
  
  func serialDidChangeState() {
    print("serialDidChangeState") // TODO: TEST REMOVE!
    reloadView()
    if !sharedInstance.serial.isPoweredOn {
      MBProgressHUD.showHUD(in: view, with: NSLocalizedString("BLUETOOTH_CONNECTIVITY_PROGRESS_HUD_MSG_BT_OFF", comment: ""))
    }
  }
  
}


// MARK: - BluetoothScanningCellDelegate protocol
extension BluetoothConnectivityViewController: BluetoothScanningCellDelegate {
  
  func bluetoothScanningCell(_ bluetoothScanningCell: BluetoothScanningTableViewCell, didPressConnect button: UIButton) {
    print("didPressConnect at row: \(button.tag)") // TODO: TEST REMOVE!
    sharedInstance.serial.stopScan()
    
    let row = button.tag
    guard let selectedPeripheral = peripherals[row].peripheral else { return }
    self.selectedPeripheral = selectedPeripheral
    sharedInstance.serial.connectToPeripheral(selectedPeripheral)
    MBProgressHUD.showHUD(in: view, with: NSLocalizedString("BLUETOOTH_CONNECTIVITY_PROGRESS_HUD_MSG_CONNECTING", comment: ""))
    scheduleTimerForConnectTimeOut()
  }
  
  
  @objc func connectTimeOut() {
    guard !sharedInstance.serial.isConnectedToPeripheral else { return }
    
    if let _ = selectedPeripheral {
      sharedInstance.serial.disconnect()
      selectedPeripheral = nil
    }
    
    MBProgressHUD.showHUD(in: view, with: NSLocalizedString("BLUETOOTH_CONNECTIVITY_PROGRESS_HUD_MSG_FAILED_TO_CONNECT", comment: ""))
  }
  
  
  @objc func scanTimeOut() {
    sharedInstance.serial.stopScan()
    searchDevicesButton.isEnabled = true
    connectivityTitleLabel.text = NSLocalizedString("BLUETOOTH_CONNECTIVITY_LABEL_TITLE_DONE_SCANNING", comment: "")
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

