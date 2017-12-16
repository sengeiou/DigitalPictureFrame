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
import NVActivityIndicatorView

class BluetoothConnectivityViewController: UIViewController {
  let sharedBluetoothManager = BluetoothManager.shared()
  
  @IBOutlet weak var centralManagerStateLabel: UILabel!
//  @IBOutlet weak var searchDevicesButton: ShadowButton!
  @IBOutlet weak var tableView: UITableView!
//  @IBOutlet weak var centralSentProgressStackView: UIStackView!
//  @IBOutlet weak var centralSentProgressBar: UIProgressView!
//  @IBOutlet weak var centralSentProgressLabel: UILabel!
  
  lazy private var scanningIndicator: NVActivityIndicatorView = {
    let tableViewSize = self.tableView.frame.size
    let size = CGSize(width: 25, height: 25)
    let originPoint = CGPoint(x: (tableViewSize.width / 2) - (size.width / 2), y: (tableViewSize.height / 2) - (size.height / 2))
    let frame = CGRect(origin: originPoint, size: size)
    let indicator = NVActivityIndicatorView(frame: frame, type: .ballScaleRippleMultiple, color: UIColor.appleBlue)
    self.tableView.addSubview(indicator)
    return indicator
  }()
  
  private var bluetoothConnectingView: BluetoothConnectingView?
  private var dataSourceDelegate: BluetoothConnectivityDataSourceDelegate?
  private var selectedPeripheral: CBPeripheral?
  private var peripherals: [PeripheralItem] = [] {
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
    
    
    if sharedBluetoothManager.connectedPeripheral != nil {
      sharedBluetoothManager.disconnectPeripheral()
    }
    
    sharedBluetoothManager.startScanPeripheral()
    
    setupStyle()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setupLayout()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    sharedBluetoothManager.stopScanPeripheral()
  }
}


// MARK: - ViewSetupable protocol
extension BluetoothConnectivityViewController: ViewSetupable {
  
  func setup() {
    sharedBluetoothManager.delegate = self
    dataSourceDelegate = BluetoothConnectivityDataSource(self, items: peripherals)
    
    tableView.register(cell: BluetoothScanningTableViewCell.self)
    tableView.dataSource = dataSourceDelegate
    tableView.delegate = dataSourceDelegate
    tableView.isScrollEnabled = false
    tableView.tableFooterView = UIView(frame: .zero)
  }
  
  
  func setupStyle() {
    typealias BluetoothStyle = Style.BluetoothConnectivityVC
//    searchDevicesButton.titleLabel?.font = BluetoothStyle.buttonTitleFont
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
    renderBluetoothStateTitle()
    renderButtonsTitle()
    resetProgressBar()
    reloadPeripheralsList()
  }
  
  
  func reloadPeripheralsList() {
    tableView.reloadData()
  }
  
  
  func resetProgressBar() {
//    centralSentProgressBar.progress = 0
//    centralSentProgressLabel.text = "Central sent \(Int(centralSentProgressBar.progress))%"
//    centralSentProgressStackView.isHidden = !sharedBluetoothManager.isReady
  }
  
  
  func clearPeripherals() {
    peripherals = []
  }
}


// MARK: - Render titles
private extension BluetoothConnectivityViewController {
  
  func renderBluetoothStateTitle() {
    centralManagerStateLabel.text = sharedBluetoothManager.stateDescription
  }
  
  func renderButtonsTitle() {
    if sharedBluetoothManager.isReady {
//      connectivityTitleLabel.text = sharedInstance.serial.connectedPeripheralName
//      searchDevicesButton.setTitle(NSLocalizedString("BLUETOOTH_CONNECTIVITY_BUTTON_DISCONNECT_TITLE", comment: ""), for: .normal)
//      searchDevicesButton.tintColor = .red
//      searchDevicesButton.isEnabled = true
      
//      sendJSONFileButton.setTitle(NSLocalizedString("BLUETOOTH_CONNECTIVITY_BUTTON_SEND_TITLE", comment: ""), for: .normal)
//      sendJSONFileButton.isEnabled = true
      
    } else if sharedBluetoothManager.isPoweredOn {
//      connectivityTitleLabel.text = NSLocalizedString("BLUETOOTH_CONNECTIVITY_LABEL_TITLE", comment: "")
//      searchDevicesButton.setTitle(NSLocalizedString("BLUETOOTH_CONNECTIVITY_BUTTON_SCAN_TITLE", comment: ""), for: .normal)
//      searchDevicesButton.tintColor = view.tintColor
//      searchDevicesButton.isEnabled = true
      
//      sendJSONFileButton.setTitle(NSLocalizedString("BLUETOOTH_CONNECTIVITY_BUTTON_SEND_TITLE", comment: ""), for: .normal)
//      sendJSONFileButton.isEnabled = false
      
    } else {
//      connectivityTitleLabel.text = NSLocalizedString("BLUETOOTH_CONNECTIVITY_LABEL_TITLE", comment: "")
//      searchDevicesButton.setTitle(NSLocalizedString("BLUETOOTH_CONNECTIVITY_BUTTON_SCAN_TITLE", comment: ""), for: .normal)
//      searchDevicesButton.tintColor = view.tintColor
//      searchDevicesButton.isEnabled = false
      
//      sendJSONFileButton.setTitle(NSLocalizedString("BLUETOOTH_CONNECTIVITY_BUTTON_SEND_TITLE", comment: ""), for: .normal)
//      sendJSONFileButton.isEnabled = false
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
extension BluetoothConnectivityViewController {
  
//  func serialDidReceiveData(_ data: Data) {
//    reloadView()
//
//    MBProgressHUD.showHUD(in: view, with: NSLocalizedString("BLUETOOTH_CONNECTIVITY_PROGRESS_HUD_MSG_PERIPHERAL_RECEIVED_DATA", comment: ""))
//
//    let stringFromData = String(data: data, encoding: String.Encoding.utf8)!
//    print(stringFromData)
//    let jsonString = stringFromData.replacingOccurrences(of: BluetoothSerial.newLineEndOfMessage, with: "")
//    print(jsonString)
//    let jsonDataWithoutEOM = jsonString.data(using: String.Encoding.utf8)!
//
//    if let json = try? JSONSerialization.jsonObject(with: jsonDataWithoutEOM, options: .allowFragments) {
//      print("DigitalPictureFrameData JSON:\n" + String(describing: json) + "\n")
//    }
//  }
  
  
//  func serialDidSendToPeripheral(data: Data, totalExpectedToSend: Data) {
//    guard peripheralReceiveProgressBar.progress < 1 else { return }
//
//    let progressRatio: Float = (Float(data.count) / Float(totalExpectedToSend.count))
//    peripheralReceiveProgressLabel.text = "Arduino received \(Int(progressRatio * 100))%"
//    peripheralReceiveProgressBar.setProgress(progressRatio, animated: true)
//    peripheralReceiveProgressLabel.setNeedsDisplay()
//    peripheralReceiveProgressBar.setNeedsDisplay()
//  }
  
  func serialIsReady(_ peripheral: CBPeripheral) {
    reloadView()
  }
  
}


// MARK: - BluetoothScanningCellDelegate protocol
extension BluetoothConnectivityViewController: BluetoothScanningCellDelegate {
  
  func bluetoothScanningCell(_ bluetoothScanningCell: BluetoothScanningTableViewCell, didPressConnect button: UIButton) {
    let row = button.tag
    selectedPeripheral = peripherals[row].peripheral
    
    BluetoothConnectingView.showWith(name: selectedPeripheral!.name!)
    sharedBluetoothManager.connectPeripheral(selectedPeripheral!)
    sharedBluetoothManager.stopScanPeripheral()
    bluetoothScanningCell.configureConnectedButton()
  }
  
}


// MARK: - Send data to Arduino
private extension BluetoothConnectivityViewController {
  
//  func sendDataToArduino() {
//    guard let dataForArduino = DatabaseManager.shared().encodedJsonData else { return }
//    sendJSONFileButton.isEnabled = false
//
//    sharedInstance.serial.sendDataToDevice(dataForArduino) { [weak self] bytesSent, totalBytesExpectedToSend in
//      guard let strongSelf = self else { return }
//      DispatchQueue.main.async {
//        guard strongSelf.centralSentProgressBar.progress < 1 else { return }
//
//        let progressRatio: Float = (Float(bytesSent) / Float(totalBytesExpectedToSend))
//        print("Central sent \(Int(progressRatio * 100))%")
//        strongSelf.centralSentProgressLabel.text = "Central sent \(Int(progressRatio * 100))%"
//        strongSelf.centralSentProgressBar.setProgress(progressRatio, animated: true)
//        strongSelf.centralSentProgressLabel.setNeedsDisplay()
//        strongSelf.centralSentProgressBar.setNeedsDisplay()
//      }
//    }
//  }
  
}


// MARK: - Actions
private extension BluetoothConnectivityViewController {
  
  @IBAction func sendJSONButtonPressed(_ sender: UIButton) {
//    if !sharedInstance.serial.isReady {
//      let title = NSLocalizedString("BLUETOOTH_CONNECTIVITY_ALERT_TITLE_NOT_CONNECTED", comment: "")
//      let message = NSLocalizedString("BLUETOOTH_CONNECTIVITY_ALERT_MESSAGE_NOT_CONNECTED", comment: "")
//      AlertViewPresenter.sharedInstance.presentPopupAlert(in: self, title: title, message: message)
//      
//    } else {
//      resetProgressBar()
//      sendDataToArduino()
//    }
  }
  
  
  @IBAction func scanDevicesButtonPressed(_ sender: UIButton) {
    if !sharedBluetoothManager.isConnectedToPeripheral {
      clearPeripherals()
      hideNoPeripheralsAvailableMessage()
      startScanningIndicator()
      sharedBluetoothManager.startScanPeripheral()
//      searchDevicesButton.isEnabled = false
      
    } else {
      sharedBluetoothManager.disconnectPeripheral()
      reloadView()
    }
  }
  
}


// MARK: - BluetoothDelegate protocol
extension BluetoothConnectivityViewController: BluetoothDelegate {
  
  func didDiscoverPeripheral(_ peripheral: CBPeripheral, advertisementData: [String: Any], RSSI: NSNumber) {
    if let exisitingPeripheral = peripherals.filter({ $0.peripheral.identifier == peripheral.identifier }).first {
      exisitingPeripheral.RSSI = RSSI.floatValue
      
    } else {
      let foundPeripheral = PeripheralItem(peripheral: peripheral, advertisementData: advertisementData, RSSI: RSSI.floatValue)
      peripherals.append(foundPeripheral)
      peripherals.sort { $0.RSSI < $1.RSSI }
    }
    
    renderNoPeripheralsAvailableMessage()
    tableView.reloadData()
  }
  
  /**
   The bluetooth state monitor
   
   - parameter state: The bluetooth state
   */
  func didUpdateState(_ state: CBManagerState) {
    print("BluetoothConnectivityViewController --> didUpdateState:\(state)")
    
    switch state {
    case .resetting:
      print("BluetoothConnectivityViewController --> State : Resetting")
      
    case .poweredOn:
      print("BluetoothConnectivityViewController --> State : Powered On")
      sharedBluetoothManager.startScanPeripheral()
      clearPeripherals()
      reloadView()
      renderNoPeripheralsAvailableMessage()
      
    case .poweredOff:
      print(" BluetoothConnectivityViewController -->State : Powered Off")
      fallthrough
      
    case .unauthorized:
      print("BluetoothConnectivityViewController --> State : Unauthorized")
      fallthrough
      
    case .unknown:
      print("BluetoothConnectivityViewController --> State : Unknown")
      fallthrough
      
    case .unsupported:
      print("BluetoothConnectivityViewController --> State : Unsupported")
      sharedBluetoothManager.stopScanPeripheral()
      sharedBluetoothManager.disconnectPeripheral()
      BluetoothConnectingView.hide()
      clearPeripherals()
      reloadView()
      renderNoPeripheralsAvailableMessage()
      
    }
  }
  
  
  func didConnectedPeripheral(_ connectedPeripheral: CBPeripheral) {
    print("BluetoothConnectivityViewController --> didConnectedPeripheral")
    MBProgressHUD.showHUD(in: view, with: NSLocalizedString("BLUETOOTH_CONNECTIVITY_PROGRESS_HUD_MSG_CONNECTED", comment: ""))
//    connectingView?.tipLbl.text = "Interrogating..."
  }
  
  
  func didDisconnectPeripheral(_ peripheral: CBPeripheral) {
    reloadView()
    MBProgressHUD.showHUD(in: view, with: NSLocalizedString("BLUETOOTH_CONNECTIVITY_PROGRESS_HUD_MSG_DISCONNECTED", comment: ""))
  }
  
  
  func didDiscoverServices(_ peripheral: CBPeripheral) {
    print("BluetoothConnectivityViewController --> didDiscoverService:\(String(describing: peripheral.services))")
    BluetoothConnectingView.hide()
    
    let storyboard = UIStoryboard(storyboard: .main)
    let peripheralViewController = storyboard.instantiateViewController(PeripheralViewController.self)
    let peripheralInfo = peripherals.filter({ $0.peripheral.isEqual(peripheral) }).first
    peripheralViewController.lastAdvertisementData = peripheralInfo?.advertisementData
    self.present(peripheralViewController, animated: true)
  }
  
  
  func didFailedToInterrogate(_ peripheral: CBPeripheral) {
    let title = "Connection Alert"
    let message = "The perapheral disconnected while being interrogated."
    AlertViewPresenter.sharedInstance.presentPopupAlert(in: self, title: title, message: message)
  }
  
}
