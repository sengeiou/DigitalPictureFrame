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
    BluetoothConnectingView.conectingInProgressWith(title: NSLocalizedString("BLUETOOTH_CONNECTING_VIEW_LABEL_TITLE_INTERROGATE", comment: ""))
  }
  
  
  func didDisconnectPeripheral(_ peripheral: CBPeripheral) {
    MBProgressHUD.showHUD(in: view, with: NSLocalizedString("BLUETOOTH_CONNECTIVITY_PROGRESS_HUD_MSG_DISCONNECTED", comment: ""))
    reloadView()
  }
  
  
  func didDiscoverServices(_ peripheral: CBPeripheral) {
    print("BluetoothConnectivityViewController --> didDiscoverService:\(String(describing: peripheral.services))")
    BluetoothConnectingView.hide()
    presentPeripheralViewController()
  }
  
  
  func didFailToInterrogate(_ peripheral: CBPeripheral) {
    let title = NSLocalizedString("BLUETOOTH_CONNECTIVITY_ALERT_CONNECTION_TITLE", comment: "")
    let message = NSLocalizedString("BLUETOOTH_CONNECTIVITY_ALERT_MESSAGE_FAILED_INTERROGATE", comment: "")
    BluetoothConnectingView.hide()
    AlertViewPresenter.sharedInstance.presentPopupAlert(in: self, title: title, message: message)
  }
  
  
  func didFailToConnectPeripheral(_ peripheral: CBPeripheral, error: Error) {
    let title = NSLocalizedString("BLUETOOTH_CONNECTIVITY_ALERT_CONNECTION_TITLE", comment: "")
    let message = error.localizedDescription
    BluetoothConnectingView.hide()
    AlertViewPresenter.sharedInstance.presentPopupAlert(in: self, title: title, message: message)
  }
}


// MARK: - Present BluetoothPeripheralViewController
private extension BluetoothConnectivityViewController {
  
  func presentPeripheralViewController() {
    let storyboard = UIStoryboard(storyboard: .main)
    let peripheralViewController = storyboard.instantiateViewController(BluetoothPeripheralViewController.self)
    let characteriticServiceItem = CharacteristicServiceItem(advertisementData: selectedPeripheral?.advertisementData)
    peripheralViewController.characteriticServiceItem = characteriticServiceItem
    self.present(peripheralViewController, animated: true)
  }
  
}


// MARK: - BluetoothScanningCellDelegate protocol
extension BluetoothConnectivityViewController: BluetoothScanningCellDelegate {
  
  func bluetoothScanningCell(_ bluetoothScanningCell: BluetoothScanningTableViewCell, didPressConnect button: UIButton) {
    let row = button.tag
    selectedPeripheral = availablePeripherals[row]
    
    BluetoothConnectingView.showWithSubtitle(selectedPeripheral!.name)
    sharedBluetoothManager.connectPeripheral(selectedPeripheral!.peripheral)
    stopScanPeripherals()
  }
  
}
