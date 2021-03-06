//
//  BluetoothPeripheralViewController.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit
import CoreBluetooth
import MBProgressHUD

class BluetoothPeripheralViewController: UIViewController, UINavigationBarDelegate {
  typealias PeripheralStyle = Style.BluetoothPeripheralVC
  
  private let sharedBluetoothManager = BluetoothManager.shared()
  private var isListeningNotifications = false
  
  @IBOutlet weak var navigationBar: UINavigationBar!
  @IBOutlet weak var peripheralNameLabel: UILabel!
  @IBOutlet weak var peripheralUUIDLabel: UILabel!
  @IBOutlet weak var connectedLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!
  
  var peripheralServiceItem: PeripheralServiceItem?
  private var dataModelSource: BluetoothPeripheralDataModelDelegate?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setup()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupStyle()
    sharedBluetoothManager.delegate = self
  }
  
  deinit {
    unregisterNotification()
  }
}



// MARK: - ViewSetupable protocol
extension BluetoothPeripheralViewController: ViewSetupable {
  
  func setup() {
    
    do {
      sharedBluetoothManager.delegate = self
      try sharedBluetoothManager.discoverCharacteristics()
      
      tableView.register(cell: BluetoothPeripheralAdvertisementTableViewCell.self)
      tableView.register(cell: BluetoothCharacteristicTableViewCell.self)
      
      dataModelSource = BluetoothPeripheralDataModel(peripheralServiceItem: peripheralServiceItem)
      tableView.dataSource = dataModelSource
      tableView.delegate = dataModelSource
      tableView.isScrollEnabled = true
      tableView.separatorStyle = .none
      tableView.tableFooterView = UIView(frame: .zero)
      
      peripheralNameLabel.text = sharedBluetoothManager.connectedPeripheral?.name
      peripheralUUIDLabel.text = sharedBluetoothManager.connectedPeripheral?.identifier.uuidString
      reloadTableView()
      registerNotification()
      
    } catch let error as BluetoothError {
      BluetoothError.handle(error: error)
    } catch {
      BluetoothError.handle(error: .unsupportedError)
    }
  }
  
  func setupStyle() {
    renderStatusBarBackgroundColor()
    setupNavigationBar()
    setupLabels()
  }
  
}


// MARK: - Reload TableView
extension BluetoothPeripheralViewController {
  
  func reloadTableView() {
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }
  
}


// MARK: - Render titles
private extension BluetoothPeripheralViewController {
  
  func renderStatusBarBackgroundColor() {
    let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
    statusBarView.backgroundColor = Style.StatusBarView.backgroundColor
    view.addSubview(statusBarView)
  }
  
  func setupNavigationBar() {
    navigationBar.barTintColor = PeripheralStyle.navigationBarBackgroundColor
    navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: PeripheralStyle.navigationBarTextColor]
    navigationBar.topItem?.title = NSLocalizedString("BLUETOOTH_PERIPHERAL_NAVIGATIONBAR_TITLE", comment: "")
  }
  
  func setupLabels() {
    peripheralNameLabel.font = PeripheralStyle.peripheralNameLabelFont
    peripheralNameLabel.numberOfLines = PeripheralStyle.peripheralNameLabelNumberOfLines
    peripheralNameLabel.textAlignment = PeripheralStyle.peripheralNameLabelAlignment
    
    peripheralUUIDLabel.font = PeripheralStyle.peripheralUUIDLabelFont
    peripheralUUIDLabel.numberOfLines = PeripheralStyle.peripheralUUIDLabelNumberOfLines
    peripheralUUIDLabel.textAlignment = PeripheralStyle.peripheralUUIDLabelAlignment
    
    connectedLabel.text = NSLocalizedString("BLUETOOTH_PERIPHERAL_LABEL_CONNECTED_STATUS", comment: "")
    connectedLabel.font = PeripheralStyle.connectedLabelFont
    connectedLabel.textColor = PeripheralStyle.connectedLabelTextColor
    connectedLabel.numberOfLines = PeripheralStyle.connectedLabelNumberOfLines
    connectedLabel.textAlignment = PeripheralStyle.connectedLabelAlignment
  }
  
}

// MARK: - Present Characteristic View Controller Notification
extension BluetoothPeripheralViewController {
  func registerNotification() {
    addPresentCharacteristicVCNofificationObserver()
  }
  
  func unregisterNotification() {
    removePresentCharacteristicVCNofificationObserver()
  }
  
  
  func addPresentCharacteristicVCNofificationObserver() {
    NotificationCenter.default.addObserver(self, selector: #selector(BluetoothPeripheralViewController.presentCharacteristicViewController(_:)),
                                           name: NotificationName.presentCharacteristicViewController.name, object: nil)
  }
  
  func removePresentCharacteristicVCNofificationObserver() {
    NotificationCenter.default.removeObserver(self, name: NotificationName.presentCharacteristicViewController.name, object: nil)
  }
}


// MARK: - Present Characteristic View Controller
extension BluetoothPeripheralViewController {
  
  @objc func presentCharacteristicViewController(_ notification: NSNotification) {
    guard let characteristic = notification.userInfo?[NotificationUserInfoKey.peripheralCharacteristic.rawValue] as? CBCharacteristic else { return }
    let bluetoothStoryboard = UIStoryboard(storyboard: .bluetooth)
    let characteristicVC = bluetoothStoryboard.instantiateViewController(BluetoothCharacteristicViewController.self)
    characteristicVC.selectedCharacteristic = characteristic
    
    transitionPresent(characteristicVC)
    
    let message = "Did present Characteristic \(characteristic.name)"
    Logger.logInfo(message: message)
  }
  
}


// MARK: - Actions
private extension BluetoothPeripheralViewController {
  
  @IBAction func backBarButtonPressed(_ sender: UIBarButtonItem) {
    transitionDismiss()
  }
  
}


// MARK: - BluetoothDelegate protocol
extension BluetoothPeripheralViewController: BluetoothDelegate {
  
  func didDisconnectPeripheral(_ peripheral: CBPeripheral) {
    let message = "Did disconnect Peripheral \(peripheral.name ?? "Unnamed")"
    Logger.logInfo(message: message)
    
    MBProgressHUD.showHUD(in: view, with: NSLocalizedString("BLUETOOTH_CONNECTIVITY_PROGRESS_HUD_MSG_DISCONNECTED", comment: ""))
    connectedLabel.text = NSLocalizedString("BLUETOOTH_PERIPHERAL_LABEL_DISCONNECTED_STATUS", comment: "")
    connectedLabel.textColor = .red
  }
  
  func didDiscoverCharacteritics(_ service: CBService) {
    let message = "Did discover Characteritics \(String(describing: peripheralServiceItem?.characteristics)))"
    Logger.logInfo(message: message)
    
    peripheralServiceItem?.service = service
    dataModelSource?.peripheralServiceItem = peripheralServiceItem
    reloadTableView()
  }
  
}
