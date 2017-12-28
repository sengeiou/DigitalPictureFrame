//
//  BluetoothCharacteristicViewController.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit
import CoreBluetooth
import MBProgressHUD

class BluetoothCharacteristicViewController: UIViewController {
  typealias CharacteristicStyle = Style.BluetoothCharacteristicVC
  
  @IBOutlet weak var navigationBar: UINavigationBar!
  @IBOutlet weak var peripheralNameLabel: UILabel!
  @IBOutlet weak var characteristicNameLabel: UILabel!
  @IBOutlet weak var characteristicUUIDLabel: UILabel!
  @IBOutlet weak var connectedLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!
  
  private var isListeningNotifications = false
  let sharedBluetoothManager = BluetoothManager.shared()
  var selectedCharacteristic: CBCharacteristic? {
    didSet {
      guard let selectedCharacteristic = selectedCharacteristic else { return }
      dataModelDelegate?.characteristicItem = selectedCharacteristic
      reloadTableView()
    }
  }
  var dataModelDelegate: BluetoothCharacteristicDataModelDelegate?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setup()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.setupStyle()
  }
  
  fileprivate func reloadTableView() {
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }
}


// MARK: - ViewSetupable protocol
extension BluetoothCharacteristicViewController: ViewSetupable {
  
  func setup() {
    guard let characteristic = selectedCharacteristic else {
      BluetoothError.handle(error: .peripheralNoCharacteristicAvailable)
      return
    }
    
    self.title = characteristic.name
    sharedBluetoothManager.delegate = self
    sharedBluetoothManager.discoverDescriptor(characteristic)
    peripheralNameLabel.text = sharedBluetoothManager.connectedPeripheral?.name
    characteristicNameLabel.text = characteristic.name
    characteristicUUIDLabel.text = characteristic.uuid.uuidString
    
    dataModelDelegate = BluetoothCharacteristicDataModel(self, characteristicItem: characteristic)
    tableView.register(cell: BluetoothCharacteristicActionTableViewCell.self)
    tableView.dataSource = dataModelDelegate
    tableView.delegate = dataModelDelegate
    tableView.tableFooterView = UIView(frame: .zero)
  }
  
  
  func setupStyle() {
    renderStatusBarBackgroundColor()
    setupNavigationBar()
    setupLabels()
  }
}


// MARK: - Render titles
private extension BluetoothCharacteristicViewController {
  
  func renderStatusBarBackgroundColor() {
    let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
    let statusBarColor = UIColor.groupGray
    statusBarView.backgroundColor = statusBarColor
    view.addSubview(statusBarView)
  }
  
  func setupNavigationBar() {
    navigationBar.barTintColor = CharacteristicStyle.navigationBarBackgroundColor
    navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: CharacteristicStyle.navigationBarTextColor]
    navigationBar.topItem?.title = NSLocalizedString("BLUETOOTH_CHARACTERISTIC_NAVIGATIONBAR_TITLE", comment: "")
  }
  
  func setupLabels() {
    peripheralNameLabel.font = CharacteristicStyle.peripheralNameLabelFont
    peripheralNameLabel.numberOfLines = CharacteristicStyle.peripheralNameLabelNumberOfLines
    peripheralNameLabel.textAlignment = CharacteristicStyle.peripheralNameLabelAlignment
    
    characteristicNameLabel.font = CharacteristicStyle.peripheralUUIDLabelFont
    characteristicNameLabel.numberOfLines = CharacteristicStyle.peripheralUUIDLabelNumberOfLines
    characteristicNameLabel.textAlignment = CharacteristicStyle.peripheralUUIDLabelAlignment
    
    characteristicUUIDLabel.font = CharacteristicStyle.peripheralUUIDLabelFont
    characteristicUUIDLabel.numberOfLines = CharacteristicStyle.peripheralUUIDLabelNumberOfLines
    characteristicUUIDLabel.textAlignment = CharacteristicStyle.peripheralUUIDLabelAlignment
    
    connectedLabel.text = NSLocalizedString("BLUETOOTH_PERIPHERAL_LABEL_CONNECTED_STATUS", comment: "")
    connectedLabel.font = CharacteristicStyle.connectedLabelFont
    connectedLabel.textColor = CharacteristicStyle.connectedLabelTextColor
    connectedLabel.numberOfLines = CharacteristicStyle.connectedLabelNumberOfLines
    connectedLabel.textAlignment = CharacteristicStyle.connectedLabelAlignment
  }
  
}


// MARK: - BluetoothCharacteristicActionCellDelegate protocol
extension BluetoothCharacteristicViewController: BluetoothCharacteristicActionCellDelegate {
  
  func bluetoothCharacteristicActionCell(_ bluetoothCharacteristicActionCell: BluetoothCharacteristicActionTableViewCell, didPressSend button: TableSectionButton) throws {
    if !sharedBluetoothManager.isReady {
      let title = NSLocalizedString("BLUETOOTH_CONNECTIVITY_ALERT_CONNECTION_TITLE", comment: "")
      let message = NSLocalizedString("BLUETOOTH_CONNECTIVITY_ALERT_MESSAGE_PERIPHERAL_NOT_READY", comment: "")
      AlertViewPresenter.sharedInstance.presentPopupAlert(in: self, title: title, message: message)
      
    } else {
      guard let jsonDataForArduino = DatabaseManager.shared().encodedJsonData else { throw BluetoothError.encodedDataForArduinoNotAvailable }
      guard let characteristic = bluetoothCharacteristicActionCell.characteristicItem else { throw BluetoothError.peripheralNoCharacteristicAvailable }
    
      do {
        BluetoothSendingView.show()
        try sharedBluetoothManager.writeValue(data: jsonDataForArduino, forCharacteristic: characteristic, writeType: bluetoothCharacteristicActionCell.writeType, progressHandler: { bytesSent, totalBytesExpectedToSend in
          DispatchQueue.main.async {
            let progressRatio: Float = (Float(bytesSent) / Float(totalBytesExpectedToSend))
            BluetoothSendingView.sharedInstance.progress = progressRatio
            if bytesSent >= totalBytesExpectedToSend {
              BluetoothSendingView.hide()
            }
          }
        })
      } catch let error as BluetoothError {
        BluetoothSendingView.hide()
        BluetoothError.handle(error: error)
        
      } catch {
        BluetoothSendingView.hide()
        BluetoothError.handle()
      }
      
      
    }
  }
  
  
  func bluetoothCharacteristicActionCell(_ bluetoothCharacteristicActionCell: BluetoothCharacteristicActionTableViewCell, didPressListenNotifications button: TableSectionButton) throws {
    guard let characteristic = bluetoothCharacteristicActionCell.characteristicItem else { throw BluetoothError.peripheralNoCharacteristicAvailable }
    
    isListeningNotifications = !isListeningNotifications
    var title: String {
      return isListeningNotifications == false ? NSLocalizedString("BLUETOOTH_PERIPHERAL_CELL_BUTTON_LISTEN_NOTIFICATIONS_TITLE", comment: "")
        : NSLocalizedString("BLUETOOTH_PERIPHERAL_CELL_BUTTON_STOP_LISTEN_NOTIFICATIONS_TITLE", comment: "")
    }

    do {
      try sharedBluetoothManager.setNotification(enable: isListeningNotifications, forCharacteristic: characteristic)
      isListeningNotifications == false ? button.setTitle(title, for: .normal) : button.setTitle(title, for: .normal)
      
    } catch let error as BluetoothError {
      BluetoothError.handle(error: error)
      
    } catch {
      BluetoothError.handle()
    }
    
  }
}


// MARK: - BluetoothDelegate protocol
extension BluetoothCharacteristicViewController: BluetoothDelegate {

  func didDisconnectPeripheral(_ peripheral: CBPeripheral) {
    print("CharacteristicController --> didDisconnectPeripheral")
    MBProgressHUD.showHUD(in: view, with: NSLocalizedString("BLUETOOTH_CONNECTIVITY_PROGRESS_HUD_MSG_DISCONNECTED", comment: ""))
    connectedLabel.text = NSLocalizedString("BLUETOOTH_PERIPHERAL_LABEL_DISCONNECTED_STATUS", comment: "")
    connectedLabel.textColor = .red
  }
  
  func didDiscoverDescriptors(_ characteristic: CBCharacteristic) {
    print("CharacteristicController --> didDiscoverDescriptors")
    selectedCharacteristic = characteristic
  }
}


// MARK: - Actions
private extension BluetoothCharacteristicViewController {
  
  @IBAction func backBarButtonPressed(_ sender: UIBarButtonItem) {
    transitionDismiss()
  }
  
}
