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

class BluetoothConnectivityViewController: UIViewController {
  let sharedBluetoothManager = BluetoothManager.shared()
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var logFooterView: LogFooterView!
  
  private var loggerView: LoggerView?
  private var bluetoothConnectingView: BluetoothConnectingView?
  private var dataSourceDelegate: BluetoothConnectivityDataModelDelegate?
  private var selectedPeripheral: PeripheralItem?
  private var availablePeripherals: [PeripheralItem] = [] {
    didSet {
      dataSourceDelegate?.items = availablePeripherals
    }
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupStyle()
    rescanPeripherals()
  }
}


// MARK: - ViewSetupable protocol
extension BluetoothConnectivityViewController: ViewSetupable {
  
  func setup() {
    sharedBluetoothManager.delegate = self
    
    setupTableView()
    setupLogActionButton()
  }
  
  
  func setupStyle() {
    self.reloadView()
  }

}

// MARK: - Reload view
private extension BluetoothConnectivityViewController {
  
  func reloadView() {
    DispatchQueue.main.async {
      self.renderNoPeripheralsAvailableMessage()
      self.checkAndShowBluetoothPopupStateView()
      self.reloadPeripheralsList()
    }
  }
  
  
  func checkAndShowBluetoothPopupStateView() {
    PopupCentralManagerStateView.showHidePopup(on: view, with: sharedBluetoothManager.stateDescription)
    Logger.logInfo(message: sharedBluetoothManager.stateDescription)
  }
  
  
  func reloadPeripheralsList() {
    tableView.reloadData()
  }
  

  func clearPeripherals() {
    availablePeripherals = []
  }
  
  
  func rescanPeripherals() {
    if sharedBluetoothManager.connectedPeripheral != nil {
      disconnectPeripheral()
    }
    
    sharedBluetoothManager.delegate = self
    startScanPeripherals()
  }
  
  
  func startScanPeripherals() {
    sharedBluetoothManager.startScanPeripheral()
  }
  
  func stopScanPeripherals() {
    sharedBluetoothManager.stopScanPeripheral()
  }
  
  func disconnectPeripheral() {
    sharedBluetoothManager.disconnectPeripheral()
  }
}


// MARK: - Reload view
private extension BluetoothConnectivityViewController {
  
  func setupTableView() {
    dataSourceDelegate = BluetoothConnectivityDataModel(self, items: availablePeripherals)
    
    tableView.register(cell: BluetoothScanningTableViewCell.self)
    tableView.dataSource = dataSourceDelegate
    tableView.delegate = dataSourceDelegate
    tableView.isScrollEnabled = true
    tableView.bounces = false
    tableView.estimatedRowHeight = 65
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.separatorStyle = .none
    tableView.tableFooterView = UIView(frame: .zero)
  }
  
  
  func setupLogActionButton() {
    logFooterView.logButtonAction {
      LoggerView.present()
    }
  }
}



// Show/Hide No data available message
private extension BluetoothConnectivityViewController {
  
  func renderNoPeripheralsAvailableMessage() {
    func removeTableViewEmptyCells() {
      tableView.tableFooterView = UIView(frame: .zero)
    }
    
    var shouldShowAvailableMessage: Bool {
      return dataSourceDelegate?.numberOfRows == 0 ? true : false
    }
    
    
    if shouldShowAvailableMessage {
      showNoPeripheralsAvailableMessage()
      removeTableViewEmptyCells()
    } else {
      hideNoPeripheralsAvailableMessage()
    }
  }

  
  func showNoPeripheralsAvailableMessage() {
    let title = NSLocalizedString("BLUETOOTH_CONNECTIVITY_LABEL_NO_PERIPHERALS_AVAILABLE_TITLE", comment: "")
    let subtitle = NSLocalizedString("BLUETOOTH_CONNECTIVITY_LABEL_NO_PERIPHERALS_AVAILABLE_SUBTITLE", comment: "")
    AvailabilityMessageView.show(on: tableView, title: title, subtitle: subtitle)
  }
  
  
  func hideNoPeripheralsAvailableMessage() {
    AvailabilityMessageView.hide()
  }

}


// MARK: - BluetoothDelegate protocol
extension BluetoothConnectivityViewController: BluetoothDelegate {
  
  func didDiscoverPeripheral(_ peripheral: CBPeripheral, advertisementData: [String: Any], RSSI: NSNumber) {
    if let exisitingPeripheral = availablePeripherals.filter({ $0.peripheral.identifier == peripheral.identifier }).first {
      exisitingPeripheral.peripheral = peripheral
      exisitingPeripheral.RSSI = RSSI.floatValue
      
    } else {
      let foundPeripheral = PeripheralItem(peripheral: peripheral, advertisementData: advertisementData, RSSI: RSSI.floatValue)
      availablePeripherals.append(foundPeripheral)
      availablePeripherals.sort { $0.RSSI > $1.RSSI }
    }
    
    
    renderNoPeripheralsAvailableMessage()
    reloadPeripheralsList()
  }
  

  func didUpdateState(_ state: CBManagerState) {
    checkAndShowBluetoothPopupStateView()
    
    switch state {
    case .resetting:
      let message = "Did update state -> Resetting"
      Logger.logInfo(message: message)
      
    case .poweredOn:
      let message = "Did update state -> Powered On"
      Logger.logInfo(message: message)
      startScanPeripherals()
      reloadView()
      
    case .poweredOff:
      let message = "Did update state -> Powered Off"
      Logger.logInfo(message: message)
      fallthrough
      
    case .unauthorized:
      let message = "Did update state -> Unauthorized"
      Logger.logInfo(message: message)
      fallthrough
      
    case .unknown:
      let message = "Did update state -> Unknown"
      Logger.logInfo(message: message)
      fallthrough
      
    case .unsupported:
      let message = "Did update state -> Unsupported"
      Logger.logInfo(message: message)
      
      stopScanPeripherals()
      disconnectPeripheral()
      BluetoothConnectingView.hide()
      clearPeripherals()
      reloadView()
    }
  }
  
  
  func didConnectedPeripheral(_ connectedPeripheral: CBPeripheral) {
    let message = "Did connected Peripheral \(connectedPeripheral.name ?? "Unnamed")"
    Logger.logInfo(message: message)
    
    BluetoothConnectingView.conectingInProgressWith(title: NSLocalizedString("BLUETOOTH_CONNECTING_VIEW_LABEL_TITLE_INTERROGATE", comment: ""))
  }
  
  
  func didDisconnectPeripheral(_ peripheral: CBPeripheral) {
    let logMessage = "Did disconnect Peripheral \(peripheral.name ?? "Unnamed")"
    Logger.logInfo(message: logMessage)
    
    let message = NSLocalizedString("BLUETOOTH_CONNECTIVITY_PROGRESS_HUD_MSG_DISCONNECTED", comment: "")
    MBProgressHUD.showHUD(in: view, with: message)
    
    reloadView()
  }
  
  
  func didDiscoverServices(_ peripheral: CBPeripheral) {
    let message = "Did discover Service: \(String(describing: peripheral.services))"
    Logger.logInfo(message: message)
    
    BluetoothConnectingView.hide()
    presentPeripheralViewController()
  }
  
  
  func didFailToInterrogate(_ peripheral: CBPeripheral) {
    let logMessage = "Did fail to interrogate Peripheral \(peripheral.name ?? "Unnamed")"
    Logger.logInfo(message: logMessage)
    
    let title = NSLocalizedString("BLUETOOTH_CONNECTIVITY_ALERT_CONNECTION_TITLE", comment: "")
    let alertMessage = NSLocalizedString("BLUETOOTH_CONNECTIVITY_ALERT_MESSAGE_FAILED_INTERROGATE", comment: "")
    
    BluetoothConnectingView.hide()
    AlertViewPresenter.sharedInstance.presentPopupAlert(in: self, title: title, message: alertMessage)
  }
  
  
  func didFailToConnectPeripheral(_ peripheral: CBPeripheral, error: Error) {
    let logMessage = "Did fail to connect Peripheral \(peripheral.name ?? "Unnamed")"
    Logger.logInfo(message: logMessage)
    
    let title = NSLocalizedString("BLUETOOTH_CONNECTIVITY_ALERT_CONNECTION_TITLE", comment: "")
    let message = error.localizedDescription
    BluetoothConnectingView.hide()
    AlertViewPresenter.sharedInstance.presentPopupAlert(in: self, title: title, message: message)
  }
}


// MARK: - Present BluetoothPeripheralViewController
private extension BluetoothConnectivityViewController {
  
  func presentPeripheralViewController() {
    let bluetoothStoryboard = UIStoryboard(storyboard: .bluetooth)
    let peripheralViewController = bluetoothStoryboard.instantiateViewController(BluetoothPeripheralViewController.self)
    let peripheralServiceItem = PeripheralServiceItem(advertisementData: selectedPeripheral?.advertisementData ?? [:])
    peripheralViewController.peripheralServiceItem = peripheralServiceItem
    
    transitionPresent(peripheralViewController)
  }
  
}


// MARK: - BluetoothScanningCellDelegate protocol
extension BluetoothConnectivityViewController: BluetoothScanningCellDelegate {
  
  func bluetoothScanningCell(_ bluetoothScanningCell: BluetoothScanningTableViewCell, didPressConnect button: TableShadowButton) {
    guard let row = button.indexPath?.row else { return }
    
    selectedPeripheral = availablePeripherals[row]
    BluetoothConnectingView.showWithSubtitle(selectedPeripheral!.name)
    sharedBluetoothManager.connectPeripheral(selectedPeripheral!.peripheral)
    stopScanPeripherals()
    
    let message = "Did press connect Peripheral \(selectedPeripheral?.name ?? "Unnamed")"
    Logger.logInfo(message: message)
  }
  
}
