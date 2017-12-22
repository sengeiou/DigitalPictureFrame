//
//  BluetoothPeripheralViewController.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit
import CoreBluetooth 

class BluetoothPeripheralViewController: UIViewController, UINavigationBarDelegate {
  typealias PeripheralStyle = Style.BluetoothPeripheralVC
  
  private let sharedBluetoothManager = BluetoothManager.shared()
  private var isListeningNotifications = false
  
  @IBOutlet weak var navigationBar: UINavigationBar!
  @IBOutlet weak var peripheralNameLabel: UILabel!
  @IBOutlet weak var peripheralUUIDLabel: UILabel!
  @IBOutlet weak var connectedLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!
  
  var characteriticServiceItem: PeripheralCharacteristicServiceItem?
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
}



// MARK: - ViewSetupable protocol
extension BluetoothPeripheralViewController: ViewSetupable {
  
  func setup() {
    sharedBluetoothManager.delegate = self
    sharedBluetoothManager.discoverCharacteristics()
    dataModelSource = BluetoothPeripheralDataModel(self, characteriticServiceItem: characteriticServiceItem)
    
    tableView.register(cell: BluetoothPeripheralAdvertisementTableViewCell.self)
    tableView.register(cell: BluetoothPeripheralDeviceInfoTableViewCell.self)
    tableView.register(cell: BluetoothPeripheralTransferDataTableViewCell.self)
    tableView.dataSource = dataModelSource
    tableView.delegate = dataModelSource
    tableView.isScrollEnabled = true
    tableView.separatorStyle = .none
    tableView.tableFooterView = UIView(frame: .zero)
    
    peripheralNameLabel.text = sharedBluetoothManager.connectedPeripheral?.name
    peripheralUUIDLabel.text = sharedBluetoothManager.connectedPeripheral?.identifier.uuidString
    reloadTableView()
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
    let statusBarColor = UIColor.groupGray
    statusBarView.backgroundColor = statusBarColor
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


// MARK: - BluetoothPeripheralCellDelegate protocol
extension BluetoothPeripheralViewController: BluetoothPeripheralTransferDataCellDelegate {
  
  func bluetoothPeripheralCell(_ bluetoothPeripheralCell: BluetoothPeripheralTransferDataTableViewCell, didPressSend button: TableSectionButton) {
    if !sharedBluetoothManager.isReady {
      let title = NSLocalizedString("BLUETOOTH_CONNECTIVITY_ALERT_CONNECTION_TITLE", comment: "")
      let message = NSLocalizedString("BLUETOOTH_CONNECTIVITY_ALERT_MESSAGE_PERIPHERAL_NOT_READY", comment: "")
      AlertViewPresenter.sharedInstance.presentPopupAlert(in: self, title: title, message: message)
    } else {
      guard let jsonDataForArduino = DatabaseManager.shared().encodedJsonData else { return }
      guard let characteristic = bluetoothPeripheralCell.characteristicItem else { return }
      BluetoothSendingView.show()
      sharedBluetoothManager.writeValue(data: jsonDataForArduino, forCharacteristic: characteristic, writeType: bluetoothPeripheralCell.writeType, progressHandler: { bytesSent, totalBytesExpectedToSend in
        DispatchQueue.main.async {
          let progressRatio: Float = (Float(bytesSent) / Float(totalBytesExpectedToSend))
          BluetoothSendingView.sharedInstance.progress = progressRatio
          if bytesSent >= totalBytesExpectedToSend {
            BluetoothSendingView.hide()
          }
        }
      })
    }
  }
  
  
  func bluetoothPeripheralCell(_ bluetoothPeripheralCell: BluetoothPeripheralTransferDataTableViewCell, didPressListenNotifications button: TableSectionButton) {
    isListeningNotifications = !isListeningNotifications
    var title: String {
      return isListeningNotifications == false ? NSLocalizedString("BLUETOOTH_PERIPHERAL_CELL_BUTTON_LISTEN_NOTIFICATIONS_TITLE", comment: "")
        : NSLocalizedString("BLUETOOTH_PERIPHERAL_CELL_BUTTON_STOP_LISTEN_NOTIFICATIONS_TITLE", comment: "")
    }
    
    if !isListeningNotifications {
      button.setTitle(title, for: .normal)
    } else {
      button.setTitle(title, for: .normal)
    }
    
    sharedBluetoothManager.setNotification(enable: isListeningNotifications, forCharacteristic: bluetoothPeripheralCell.characteristicItem!)
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
    print("PeripheralController --> didDisconnectPeripheral")
    connectedLabel.text = NSLocalizedString("BLUETOOTH_PERIPHERAL_LABEL_DISCONNECTED_STATUS", comment: "")
    connectedLabel.textColor = .red
    
  }
  
  func didDiscoverCharacteritics(_ service: CBService) {
    characteriticServiceItem?.service = service
    dataModelSource?.characteriticServiceItem = characteriticServiceItem
    reloadTableView()
  }
  
}
