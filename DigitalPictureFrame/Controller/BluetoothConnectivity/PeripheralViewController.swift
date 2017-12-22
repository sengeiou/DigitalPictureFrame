//
//  PeripheralViewController.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit
import CoreBluetooth 

class BluetoothPeripheralViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, BluetoothDelegate, UINavigationBarDelegate {
  typealias PeripheralStyle = Style.PeripheralVC
  
  fileprivate let sharedBluetoothManager = BluetoothManager.shared()
  fileprivate var showAdvertisementData = false
  fileprivate var services: [CBService]?
  fileprivate var characteristicsDic = [CBUUID : [CBCharacteristic]]()
  
  var lastAdvertisementData: [String: Any]?
  fileprivate var advertisementDataKeys: [String]?
  
  @IBOutlet weak var navigationBar: UINavigationBar!
  @IBOutlet weak var peripheralNameLabel: UILabel!
  @IBOutlet weak var peripheralUUIDLabel: UILabel!
  @IBOutlet weak var connectedLabel: UILabel!
  @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var sendButton: UIButton!
  @IBOutlet weak var centralSentProgressBar: UIProgressView!
  
  var delegate: BluetoothPeripheralDataSourceDelegate?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setup()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupStyle()
    sharedBluetoothManager.delegate = self
  }
  
  
  @IBAction func backBarButtonPressed(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }
  
  /**
   The callback function of the Show Advertisement Data button click
   */
  @objc func showAdvertisementDataBtnClick() {
    print("PeripheralController --> showAdvertisementDataBtnClick")
    showAdvertisementData = !showAdvertisementData
    reloadTableView()
  }
  
  /**
   Reload tableView
   */
  func reloadTableView() {
    tableView.reloadData()
    
    // Fix the contentSize.height is greater than frame.size.height bug(Approximately 20 unit)
    tableViewHeight.constant = tableView.contentSize.height
  }
  
  /**
   According the characteristic property array get the properties string
   
   - parameter array: characteristic property array
   
   - returns: properties string
   */
  func getPropertiesFromArray(_ array : [String]) -> String {
    var propertiesString = "Properties:"
    let containWrite = array.contains("Write")
    for property in array {
      if containWrite && property == "Write Without Response" {
        continue
      }
      propertiesString += " " + property
    }
    return propertiesString
  }
  
  
  // MARK: Delegate
  // Mark: UITableViewDelegate
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      if showAdvertisementData {
        return advertisementDataKeys!.count
      } else {
        return 0
      }
    }
    let characteristics = characteristicsDic[services![section - 1].uuid]
    return characteristics == nil ? 0 : characteristics!.count
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    print("numberOfSectionsInTableView:\(sharedBluetoothManager.connectedPeripheral!.services!.count + 1)")
    return sharedBluetoothManager.connectedPeripheral!.services!.count + 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCell(withIdentifier: "serviceCell")
    if cell == nil {
      cell = UITableViewCell(style: .subtitle, reuseIdentifier: "serviceCell")
      cell?.selectionStyle = .none
      cell?.accessoryType = .disclosureIndicator
    }
    if (indexPath as NSIndexPath).section == 0 {
      cell?.textLabel?.text = CBAdvertisementData.getAdvertisementDataStringValue(lastAdvertisementData!, key: advertisementDataKeys![(indexPath as NSIndexPath).row])
      cell?.textLabel?.adjustsFontSizeToFitWidth = true
      
      cell?.detailTextLabel?.text = CBAdvertisementData.getAdvertisementDataName(advertisementDataKeys![(indexPath as NSIndexPath).row])
    } else {
      let characteristic = characteristicsDic[services![(indexPath as NSIndexPath).section - 1].uuid]![(indexPath as NSIndexPath).row]
      cell?.textLabel?.text = characteristic.name
      cell?.detailTextLabel?.text = getPropertiesFromArray(characteristic.getProperties())
    }
    return cell!
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    print("section:\(section)")
    let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    view.backgroundColor = UIColor(red: 239/255.0, green: 239/255.0, blue: 239/255.0, alpha: 1)
    
    let serviceNameLbl = UILabel(frame: CGRect(x: 10, y: 20, width: UIScreen.main.bounds.size.width - 100, height: 20))
    serviceNameLbl.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)
    
    view.addSubview(serviceNameLbl)
    
    if section == 0 {
      serviceNameLbl.text = "ADVERTISEMENT DATA"
      let showBtn = UIButton(type: .system)
      showBtn.frame = CGRect(x: UIScreen.main.bounds.size.width - 80, y: 20, width: 60, height: 20)
      if showAdvertisementData {
        showBtn.setTitle("Hide", for: UIControlState())
      } else {
        showBtn.setTitle("Show", for: UIControlState())
      }
      
      showBtn.addTarget(self, action: #selector(self.showAdvertisementDataBtnClick), for: .touchUpInside)
      view.addSubview(showBtn)
    } else {
      let service = sharedBluetoothManager.connectedPeripheral!.services![section - 1]
      serviceNameLbl.text = service.name
    }
    
    return view
  }
  
  // Need overide this method for fix start section from 1(not 0) in the method 'tableView:viewForHeaderInSection:' after iOS 7
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 60
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if (indexPath as NSIndexPath).section == 0 {
      
    } else {
      print("Click at section: \((indexPath as NSIndexPath).section), row: \((indexPath as NSIndexPath).row)")
      //      let controller = CharacteristicController()
      //      controller.characteristic = characteristicsDic[services![(indexPath as NSIndexPath).section - 1].uuid]![(indexPath as NSIndexPath).row]
      //      self.navigationController?.pushViewController(controller, animated: true)
    }
  }
  
  // MARK: BluetoothDelegate
  func didDisconnectPeripheral(_ peripheral: CBPeripheral) {
    print("PeripheralController --> didDisconnectPeripheral")
    connectedLabel.text = "Disconnected. Data is Stale."
    connectedLabel.textColor = UIColor.red
    
  }
  
  func didDiscoverCharacteritics(_ service: CBService) {
    print("Service.characteristics:\(String(describing: service.characteristics))")
    characteristicsDic[service.uuid] = service.characteristics
    reloadTableView()
  }
  
}


// MARK: - ViewSetupable protocol
extension PeripheralViewController: ViewSetupable {
  
  func setup() {
    navigationBar.topItem?.title = NSLocalizedString("BLUETOOTH_PERIPHERAL_NAVIGATIONBAR_TITLE", comment: "")
    
    advertisementDataKeys = ([String](lastAdvertisementData!.keys)).sorted()
    sharedBluetoothManager.discoverCharacteristics()
    services = sharedBluetoothManager.connectedPeripheral?.services
    peripheralNameLabel.text = sharedBluetoothManager.connectedPeripheral?.name
    peripheralUUIDLabel.text = sharedBluetoothManager.connectedPeripheral?.identifier.uuidString
    reloadTableView()
  }
  
  func setupStyle() {
    peripheralNameLabel.font = PeripheralStyle.peripheralNameLabelFont
    peripheralNameLabel.numberOfLines = PeripheralStyle.peripheralNameLabelNumberOfLines
    peripheralNameLabel.textAlignment = PeripheralStyle.peripheralNameLabelAlignment
    
    peripheralUUIDLabel.font = PeripheralStyle.peripheralUUIDLabelFont
    peripheralUUIDLabel.numberOfLines = PeripheralStyle.peripheralUUIDLabelNumberOfLines
    peripheralUUIDLabel.textAlignment = PeripheralStyle.peripheralUUIDLabelAlignment
    
    connectedLabel.font = PeripheralStyle.connectedLabelFont
    connectedLabel.textColor = PeripheralStyle.connectedLabelTextColor
    connectedLabel.numberOfLines = PeripheralStyle.connectedLabelNumberOfLines
    connectedLabel.textAlignment = PeripheralStyle.connectedLabelAlignment
    
    setupButtonTitle()
    setupProgressBar()
  }
}


// MARK: - Render titles
private extension PeripheralViewController {
  
  func setupProgressBar() {
    centralSentProgressBar.progress = 0
    centralSentProgressBar.isHidden = !sharedBluetoothManager.isReady
  }
  
  func setupButtonTitle() {
    sendButton.isEnabled = sharedBluetoothManager.isReady
    sendButton.setTitle(NSLocalizedString("BLUETOOTH_CONNECTIVITY_BUTTON_SEND_TITLE", comment: ""), for: .normal)
    sendButton.titleLabel?.font = PeripheralStyle.sendButtonTitleFont
    sendButton.layer.borderColor = PeripheralStyle.sendButtonBorderColor
    sendButton.layer.borderWidth = 0.5
    sendButton.layer.cornerRadius = 8
  }
}

// MARK: - Send JSON data to Arduino
private extension PeripheralViewController {
  
  func sendDataToArduino() {
    guard let dataForArduino = DatabaseManager.shared().encodedJsonData else { return }
    sendButton.isEnabled = false
    
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
extension PeripheralViewController {
  
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


// MARK: - Actions
private extension PeripheralViewController {
  
  @IBAction func sendButtonPressed(_ sender: UIButton) {
    if !sharedBluetoothManager.isReady {
      let title = NSLocalizedString("BLUETOOTH_CONNECTIVITY_ALERT_TITLE_NOT_CONNECTED", comment: "")
      let message = NSLocalizedString("BLUETOOTH_CONNECTIVITY_ALERT_MESSAGE_NOT_CONNECTED", comment: "")
      AlertViewPresenter.sharedInstance.presentPopupAlert(in: self, title: title, message: message)
    } else {
      setupProgressBar()
      sendDataToArduino()
    }
  }
  
}
