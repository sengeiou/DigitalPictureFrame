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


// MARK: - Reload TableView
extension BluetoothPeripheralViewController {

  func reloadTableView() {
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
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
    print("Service.characteristics:\(String(describing: service.characteristics))")
    characteriticServiceItem?.service = service
    dataModelSource?.characteriticServiceItem = characteriticServiceItem
    reloadTableView()
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


// MARK: - Send JSON data to Arduino
private extension BluetoothPeripheralViewController {
  
  func sendDataToArduino() {
    guard let dataForArduino = DatabaseManager.shared().encodedJsonData else { return }
//    sharedBluetoothManager.writeValue(data: dataForArduino, forCharacteristic: <#T##CBCharacteristic#>, writeType: <#T##CBCharacteristicWriteType#>, progressHandler: <#T##(Int, Int) -> ()#>)
//    sharedInstance.serial.sendDataToDevice(dataForArduino) { [weak self] bytesSent, totalBytesExpectedToSend in
//      guard let strongSelf = self else { return }
//      DispatchQueue.main.async {
//        guard strongSelf.centralSentProgressBar.progress < 1 else { return }
//
//        let progressRatio: Float = (Float(bytesSent) / Float(totalBytesExpectedToSend))
//        print("Central sent \(Int(progressRatio * 100))%")
//        strongSelf.centralSentProgressBar.setProgress(progressRatio, animated: true)
//        strongSelf.centralSentProgressLabel.setNeedsDisplay()
//        strongSelf.centralSentProgressBar.setNeedsDisplay()
//      }
//    }
  }
  
}


// MARK: - BluetoothSerialDelegate protocol
extension BluetoothPeripheralViewController {
  
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
  
}


// MARK: - BluetoothPeripheralCellDelegate protocol
extension BluetoothPeripheralViewController: BluetoothPeripheralTransferDataCellDelegate {
  
  func bluetoothPeripheralCell(_ bluetoothPeripheralCell: BluetoothPeripheralTransferDataTableViewCell, didPressSend button: PeripheralButton) {
    print("didPressSend")
  }
  
  func bluetoothPeripheralCell(_ bluetoothPeripheralCell: BluetoothPeripheralTransferDataTableViewCell, didPressListenNotifications button: PeripheralButton) {
    print("didPressListenNotifications")
    
    isListeningNotifications = !isListeningNotifications
    if !isListeningNotifications {
      button.setTitle(NSLocalizedString("BLUETOOTH_PERIPHERAL_CELL_BUTTON_LISTEN_NOTIFICATIONS_TITLE", comment: ""), for: .normal)
    } else {
      button.setTitle("Stop listening", for: .normal)
    }
    
    sharedBluetoothManager.setNotification(enable: isListeningNotifications, forCharacteristic: bluetoothPeripheralCell.characteristicItem!)
  }
  
}


// MARK: - Actions
private extension BluetoothPeripheralViewController {
  
  @IBAction func backBarButtonPressed(_ sender: UIBarButtonItem) {
    transitionDismiss()
  }
  
  
  @IBAction func sendButtonPressed(_ sender: UIButton) {
    if !sharedBluetoothManager.isReady {
      let title = NSLocalizedString("BLUETOOTH_CONNECTIVITY_ALERT_CONNECTION_TITLE", comment: "")
      let message = NSLocalizedString("BLUETOOTH_CONNECTIVITY_ALERT_MESSAGE_PERIPHERAL_NOT_READY", comment: "")
      AlertViewPresenter.sharedInstance.presentPopupAlert(in: self, title: title, message: message)
    } else {
      sendDataToArduino()
    }
  }
  
}
