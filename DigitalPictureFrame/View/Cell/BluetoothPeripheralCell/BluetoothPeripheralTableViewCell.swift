//
//  BluetoothPeripheralTableViewCell.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit
import CoreBluetooth

class BluetoothPeripheralTableViewCell: UITableViewCell {
  typealias StyleBluetoothPeripheralCell = Style.BluetoothPeripheralCell
  
  @IBOutlet weak var serviceTitleLabel: UILabel!
  @IBOutlet weak var serviceDescriptionLabel: UILabel!
  @IBOutlet weak var sendButton: UIButton!
  @IBOutlet weak var listenNotificationsButton: UIButton!
  @IBOutlet weak var centralSentProgressBar: UIProgressView!
  
  weak var delegate: BluetoothPeripheralCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setup()
    setupStyle()
  }
}


// MARK: - ViewSetupable protocol
extension BluetoothPeripheralTableViewCell: ViewSetupable {
  
  func setup() {
    sendButton.setTitle(NSLocalizedString("BLUETOOTH_PERIPHERAL_CELL_BUTTON_SEND_TITLE", comment: ""), for: .normal)
    listenNotificationsButton.setTitle(NSLocalizedString("BLUETOOTH_PERIPHERAL_CELL_BUTTON_LISTEN_NOTIFICATIONS_TITLE", comment: ""), for: .normal)
    sendButton.isEnabled = true
    listenNotificationsButton.isEnabled = true
    selectionStyle = .none
  }
  
  
  func setupStyle() {
    alpha = 1
    backgroundColor = StyleBluetoothPeripheralCell.defaultBackgroundColor
    
    setupLabels()
    setupButtonTitle()
    setupProgressBar()
  }

}



// MARK: Render
private extension BluetoothPeripheralTableViewCell {
  
  func setupLabels() {
    serviceTitleLabel.font = StyleBluetoothPeripheralCell.serviceTitleLabelFont
    serviceTitleLabel.textColor = StyleBluetoothPeripheralCell.serviceTitleLabelTextColor
    serviceTitleLabel.textAlignment = StyleBluetoothPeripheralCell.serviceTitleLabelAlignment
    serviceTitleLabel.numberOfLines = StyleBluetoothPeripheralCell.serviceTitleLabelNumberOfLines
    
    serviceDescriptionLabel.font = StyleBluetoothPeripheralCell.serviceDescriptionLabelFont
    serviceDescriptionLabel.textColor = StyleBluetoothPeripheralCell.serviceDescriptionLabelTextColor
    serviceDescriptionLabel.textAlignment = StyleBluetoothPeripheralCell.serviceDescriptionLabelAlignment
    serviceDescriptionLabel.numberOfLines = StyleBluetoothPeripheralCell.serviceDescriptionLabelNumberOfLines
  }
  
  func setupButtonTitle() {
    sendButton.setTitleColor(.red, for: .highlighted)
    sendButton.setTitleColor(.red, for: .selected)
    sendButton.titleLabel?.font = StyleBluetoothPeripheralCell.sendButtonTitleFont
    sendButton.layer.borderColor = StyleBluetoothPeripheralCell.buttonBoarderColor
    sendButton.layer.borderWidth = 0.5
    sendButton.layer.cornerRadius = 8
    
    listenNotificationsButton.setTitleColor(.red, for: .highlighted)
    listenNotificationsButton.setTitleColor(.red, for: .selected)
    listenNotificationsButton.titleLabel?.font = StyleBluetoothPeripheralCell.listenNotificationsButtonTitleFont
    listenNotificationsButton.layer.borderColor = StyleBluetoothPeripheralCell.buttonBoarderColor
    listenNotificationsButton.layer.borderWidth = 0.5
    listenNotificationsButton.layer.cornerRadius = 8
  }
  
  func setupProgressBar() {
    centralSentProgressBar.progress = 0
    centralSentProgressBar.isHidden = !BluetoothManager.shared().isReady
  }
  
}

// MARK: Configure cell
extension BluetoothPeripheralTableViewCell {
  
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
  
  
  func configureWith(item: CBCharacteristic?, at indexPath: IndexPath) {
    serviceTitleLabel.text = item?.name
    serviceDescriptionLabel.text = getPropertiesFromArray((item?.getProperties())!)

    sendButton.tag = indexPath.row
    sendButton.isEnabled = true
    
    listenNotificationsButton.tag = indexPath.row
    listenNotificationsButton.isEnabled = true
  }
}


// MARK: - ViewSetupable protocol
extension BluetoothPeripheralTableViewCell {
  
  @IBAction func sendButtonPressed(_ sender: UIButton) {
    delegate?.bluetoothPeripheralCell(self, didPressSend: sender)
  }
  
  
  @IBAction func listenNotificationsButtonPressed(_ sender: UIButton) {
    delegate?.bluetoothPeripheralCell(self, didPressListenNotifications: sender)
  }
  
}
