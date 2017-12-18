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
  private var bluetoothConnectingView: BluetoothConnectingView?
  private var dataSourceDelegate: BluetoothConnectivityDataSourceDelegate?
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
    dataSourceDelegate = BluetoothConnectivityDataSource(self, items: availablePeripherals)
    
    tableView.register(cell: BluetoothScanningTableViewCell.self)
    tableView.dataSource = dataSourceDelegate
    tableView.delegate = dataSourceDelegate
    tableView.isScrollEnabled = true
    tableView.bounces = false
    tableView.estimatedRowHeight = 60
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.tableFooterView = UIView(frame: .zero)
  }
  
  
  func setupStyle() {
    DispatchQueue.main.async {
      self.reloadView()
    }
  }

}


// MARK: - Reload view
private extension BluetoothConnectivityViewController {
  
  func reloadView() {
    renderNoPeripheralsAvailableMessage()
    checkAndShowBluetoothPopupStateView()
    reloadPeripheralsList()
  }
  
  
  func checkAndShowBluetoothPopupStateView() {
    PopupCentralManagerStateView.showHidePopup(on: view, with: sharedBluetoothManager.stateDescription)
  }
  
  
  func reloadPeripheralsList() {
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
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
    print("BluetoothConnectivityViewController --> didUpdateState:\(state)")
    checkAndShowBluetoothPopupStateView()
    
    switch state {
    case .resetting:
      print("BluetoothConnectivityViewController --> State : Resetting")
      
    case .poweredOn:
      print("BluetoothConnectivityViewController --> State : Powered On")
      startScanPeripherals()
      reloadView()
      
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
      stopScanPeripherals()
      disconnectPeripheral()
      BluetoothConnectingView.hide()
      clearPeripherals()
      reloadView()
    }
  }
  
  
  func didConnectedPeripheral(_ connectedPeripheral: CBPeripheral) {
    print("BluetoothConnectivityViewController --> didConnectedPeripheral")
//    connectingView?.tipLbl.text = "Interrogating..."
  }
  
  
  func didDisconnectPeripheral(_ peripheral: CBPeripheral) {
    MBProgressHUD.showHUD(in: view, with: NSLocalizedString("BLUETOOTH_CONNECTIVITY_PROGRESS_HUD_MSG_DISCONNECTED", comment: ""))
    reloadView()
  }
  
  
  func didDiscoverServices(_ peripheral: CBPeripheral) {
    print("BluetoothConnectivityViewController --> didDiscoverService:\(String(describing: peripheral.services))")
    BluetoothConnectingView.hide()
    
    let storyboard = UIStoryboard(storyboard: .main)
    let peripheralViewController = storyboard.instantiateViewController(BluetoothPeripheralViewController.self)
    peripheralViewController.advertisementData = selectedPeripheral?.advertisementData
    self.present(peripheralViewController, animated: true)
  }
  
  
  func didFailedToInterrogate(_ peripheral: CBPeripheral) {
    let title = "Connection Alert"
    let message = "The perapheral disconnected while being interrogated."
    AlertViewPresenter.sharedInstance.presentPopupAlert(in: self, title: title, message: message)
  }
  
}


// MARK: - BluetoothScanningCellDelegate protocol
extension BluetoothConnectivityViewController: BluetoothScanningCellDelegate {
  
  func bluetoothScanningCell(_ bluetoothScanningCell: BluetoothScanningTableViewCell, didPressConnect button: UIButton) {
    let row = button.tag
    selectedPeripheral = availablePeripherals[row]
    
    BluetoothConnectingView.showWith(name: selectedPeripheral!.name)
    sharedBluetoothManager.connectPeripheral(selectedPeripheral!.peripheral)
    stopScanPeripherals()
    bluetoothScanningCell.configureConnectedButton()
  }
  
}
