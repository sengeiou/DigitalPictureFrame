//
//  BluetoothPeripheralTransferDataTableViewCell.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit
import CoreBluetooth

class BluetoothPeripheralTransferDataTableViewCell: UITableViewCell {
  typealias StylePeripheralTransferDataCell = Style.BluetoothPeripheralTransferDataCell
  
  @IBOutlet weak var serviceTitleLabel: UILabel!
  @IBOutlet weak var propertiesDescriptionLabel: UILabel!
  @IBOutlet weak var sendButton: PeripheralButton!
  @IBOutlet weak var listenNotificationsButton: PeripheralButton!
  @IBOutlet weak var centralSentProgressBar: UIProgressView!
  
  weak var delegate: BluetoothPeripheralTransferDataCellDelegate?
  private(set) var characteristicItem: CBCharacteristic? {
    didSet {
      guard let characteristicItem = characteristicItem else { return }
      serviceTitleLabel.text = characteristicItem.name
      propertiesDescriptionLabel.text = characteristicItem.createPropertiesDescription()
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setup()
    setupStyle()
  }
}


// MARK: - ViewSetupable protocol
extension BluetoothPeripheralTransferDataTableViewCell: ViewSetupable {
  
  func setup() {
    sendButton.setTitle(NSLocalizedString("BLUETOOTH_PERIPHERAL_CELL_BUTTON_SEND_TITLE", comment: ""), for: .normal)
    listenNotificationsButton.setTitle(NSLocalizedString("BLUETOOTH_PERIPHERAL_CELL_BUTTON_LISTEN_NOTIFICATIONS_TITLE", comment: ""), for: .normal)
    sendButton.isEnabled = false
    listenNotificationsButton.isEnabled = false
    selectionStyle = .none
  }
  
  
  func setupStyle() {
    alpha = 1
    backgroundColor = StylePeripheralTransferDataCell.defaultBackgroundColor
    
    setupLabels()
    setupButtonTitle()
    setupProgressBar()
  }

}



// MARK: Render
private extension BluetoothPeripheralTransferDataTableViewCell {
  
  func setupLabels() {
    serviceTitleLabel.font = StylePeripheralTransferDataCell.serviceTitleLabelFont
    serviceTitleLabel.textColor = StylePeripheralTransferDataCell.serviceTitleLabelTextColor
    serviceTitleLabel.textAlignment = StylePeripheralTransferDataCell.serviceTitleLabelAlignment
    serviceTitleLabel.numberOfLines = StylePeripheralTransferDataCell.serviceTitleLabelNumberOfLines
    
    propertiesDescriptionLabel.font = StylePeripheralTransferDataCell.propertiesDescriptionLabelFont
    propertiesDescriptionLabel.textColor = StylePeripheralTransferDataCell.propertiesDescriptionLabelTextColor
    propertiesDescriptionLabel.textAlignment = StylePeripheralTransferDataCell.propertiesDescriptionLabelAlignment
    propertiesDescriptionLabel.numberOfLines = StylePeripheralTransferDataCell.propertiesDescriptionLabelNumberOfLines
  }
  
  func setupButtonTitle() {
    sendButton.setTitleColor(.red, for: .highlighted)
    sendButton.setTitleColor(.red, for: .selected)
    sendButton.titleLabel?.font = StylePeripheralTransferDataCell.sendButtonTitleFont
    sendButton.layer.borderColor = StylePeripheralTransferDataCell.buttonBoarderColor
    sendButton.layer.borderWidth = 0.5
    sendButton.layer.cornerRadius = 8
    
    listenNotificationsButton.setTitleColor(.red, for: .highlighted)
    listenNotificationsButton.setTitleColor(.red, for: .selected)
    listenNotificationsButton.titleLabel?.font = StylePeripheralTransferDataCell.listenNotificationsButtonTitleFont
    listenNotificationsButton.layer.borderColor = StylePeripheralTransferDataCell.buttonBoarderColor
    listenNotificationsButton.layer.borderWidth = 0.5
    listenNotificationsButton.layer.cornerRadius = 8
  }
  
  func setupProgressBar() {
    centralSentProgressBar.progress = 0
    centralSentProgressBar.isHidden = !BluetoothManager.shared().isReady
  }
  
}

// MARK: Configure cell
extension BluetoothPeripheralTransferDataTableViewCell {

  func configureWith(item: CBCharacteristic?, at indexPath: IndexPath) {
    guard let item = item else { return }
    
    characteristicItem = item
    let characteristicProperties = item.getProperties()
    let isContainWriteProperty = characteristicProperties.contains(.write)
    let isContainNotifyProperty = characteristicProperties.contains(.notify)
    
    sendButton.isEnabled = isContainWriteProperty
    listenNotificationsButton.isEnabled = isContainNotifyProperty
    sendButton.indexPath = indexPath
    listenNotificationsButton.indexPath = indexPath
  }
}


// MARK: - ViewSetupable protocol
extension BluetoothPeripheralTransferDataTableViewCell {
  
  @IBAction func sendButtonPressed(_ sender: PeripheralButton) {
    delegate?.bluetoothPeripheralCell(self, didPressSend: sender)
  }
  
  
  @IBAction func listenNotificationsButtonPressed(_ sender: PeripheralButton) {
    delegate?.bluetoothPeripheralCell(self, didPressListenNotifications: sender)
  }
  
}
