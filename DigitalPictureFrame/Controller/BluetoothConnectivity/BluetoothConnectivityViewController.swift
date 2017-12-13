//
//  BluetoothConnectivityViewController.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit
import CoreBluetooth
import MBProgressHUD
import GTProgressBar
import NVActivityIndicatorView

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
  
  lazy private var progressBar: GTProgressBar = {
    let progress = GTProgressBar(frame: CGRect(x: 0, y: 0, width: 300, height: 15))
    progress.progress = 1
    progress.barBorderColor = UIColor(red:0.35, green:0.80, blue:0.36, alpha:1.0)
    progress.barFillColor = UIColor(red:0.35, green:0.80, blue:0.36, alpha:1.0)
    progress.barBackgroundColor = UIColor(red:0.77, green:0.93, blue:0.78, alpha:1.0)
    progress.barBorderWidth = 1
    progress.barFillInset = 2
    progress.labelTextColor = UIColor(red:0.35, green:0.80, blue:0.36, alpha:1.0)
    progress.progressLabelInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    progress.font = UIFont.boldSystemFont(ofSize: 18)
    progress.labelPosition = GTProgressBarLabelPosition.right
    progress.barMaxHeight = 12
    progress.direction = GTProgressBarDirection.anticlockwise
    return progress
  }()
  
  private var dataSourceDelegate: BluetoothConnectivityDataSourceDelegate?
  private var sharedInstance = BluetoothSerialSingleton.sharedInstance
  private var selectedPeripheral: CBPeripheral?
  private var peripherals: [PeripheralItem] = [] {
    didSet {
      dataSourceDelegate?.items = peripherals
    }
  }
  
  
  lazy private var dataToSend: Data? = {
    if let data = DatabaseManager.shared().data, let encodedData = try? JSONEncoder().encode(data) {
      if let _ = try? JSONSerialization.jsonObject(with: encodedData, options: .allowFragments) {
        //          print("DigitalPictureFrameData JSON:\n" + String(describing: json) + "\n")
        return encodedData
      }
    }
    
    return nil
  }()
  

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
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    sharedInstance.serial.stopScan()
  }
}


// MARK: - ViewSetupable protocol
extension BluetoothConnectivityViewController: ViewSetupable {
  
  func setup() {
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
      
      sendJSONFileButton.setTitle(NSLocalizedString("BLUETOOTH_CONNECTIVITY_BUTTON_SEND_TITLE", comment: ""), for: .normal)
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
  
  func reloadData() {
    tableView.reloadData()
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
    reloadView()
    MBProgressHUD.showHUD(in: view, with: NSLocalizedString("BLUETOOTH_CONNECTIVITY_PROGRESS_HUD_MSG_FAILED_TO_CONNECT", comment: ""))
  }

  
  func serialDidReceiveData(_ data: Data) {
    MBProgressHUD.showHUD(in: view, with: NSLocalizedString("BLUETOOTH_CONNECTIVITY_PROGRESS_HUD_MSG_PERIPHERAL_RECEIVED_DATA", comment: ""))
    
    if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
      print("DigitalPictureFrameData JSON:\n" + String(describing: json) + "\n")
    }
  }
  
  
  func serialDidConnect(_ peripheral: CBPeripheral) {
    MBProgressHUD.showHUD(in: view, with: NSLocalizedString("BLUETOOTH_CONNECTIVITY_PROGRESS_HUD_MSG_CONNECTED", comment: ""))
  }
  
  
  func serialDidDisconnect(_ peripheral: CBPeripheral, error: NSError?) {
    reloadView()
    reloadData()
    MBProgressHUD.showHUD(in: view, with: NSLocalizedString("BLUETOOTH_CONNECTIVITY_PROGRESS_HUD_MSG_DISCONNECTED", comment: ""))
  }
  
  func serialIsReady(_ peripheral: CBPeripheral) {
    reloadView()
  }
  
  func serialDidChangeState() {
    reloadView()
    if !sharedInstance.serial.isPoweredOn {
      MBProgressHUD.showHUD(in: view, with: NSLocalizedString("BLUETOOTH_CONNECTIVITY_PROGRESS_HUD_MSG_BT_OFF", comment: ""))
    }
  }
  
  
  func serialDidSendBytes(chunk: Int, of data: Int) {
    print("serialDidSend: \(chunk) from \(data)")
    let progress = (Float(chunk) / Float(data))
    print("Progress: \(progress)")
    progressBar.animateTo(progress: CGFloat(progress))
  }
  
}


// MARK: - BluetoothScanningCellDelegate protocol
extension BluetoothConnectivityViewController: BluetoothScanningCellDelegate {
  
  func bluetoothScanningCell(_ bluetoothScanningCell: BluetoothScanningTableViewCell, didPressConnect button: UIButton) {
    sharedInstance.serial.stopScan()
    
    let row = button.tag
    guard let selectedPeripheral = peripherals[row].peripheral else { return }
    self.selectedPeripheral = selectedPeripheral
    sharedInstance.serial.connectToPeripheral(selectedPeripheral)
    bluetoothScanningCell.configureConnectedButton()
    scheduleTimerForConnectTimeOut()
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


// MARK: - Actions
extension BluetoothConnectivityViewController {
  
  @IBAction func sendJSONButtonPressed(_ sender: UIButton) {
    if !sharedInstance.serial.isReady {
      let title = NSLocalizedString("BLUETOOTH_CONNECTIVITY_ALERT_TITLE_NOT_CONNECTED", comment: "")
      let message = NSLocalizedString("BLUETOOTH_CONNECTIVITY_ALERT_MESSAGE_NOT_CONNECTED", comment: "")
      AlertViewPresenter.sharedInstance.presentPopupAlert(in: self, title: title, message: message)
    } else {
      guard let dataToSend = dataToSend else { return }
      sharedInstance.serial.sendDataToDevice(dataToSend)
      view.addSubview(progressBar)
    }
  }
  
  
  @IBAction func scanDevicesButtonPressed(_ sender: UIButton) {
    if !sharedInstance.serial.isConnectedToPeripheral {
      clearPeripherals()
      hideNoPeripheralsAvailableMessage()
      startScanningIndicator()
      sharedInstance.serial.startScan()
      connectivityTitleLabel.text = NSLocalizedString("BLUETOOTH_CONNECTIVITY_LABEL_TITLE_SCANNING", comment: "")
      searchDevicesButton.isEnabled = false
      scheduleTimerForScanTimeOut()
      
    } else {
      sharedInstance.serial.disconnect()
      reloadView()
    }
  }
  
}

