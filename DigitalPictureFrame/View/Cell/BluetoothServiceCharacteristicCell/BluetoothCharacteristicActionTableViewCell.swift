//
//  BluetoothCharacteristicActionTableViewCell.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit
import CoreBluetooth

open class BluetoothCharacteristicActionTableViewCell: UITableViewCell {
  typealias CharacteristicActionStyle = Style.BluetoothCharacteristicActionCell
  
  @IBOutlet weak var sendButton: TableSectionButton!
  @IBOutlet weak var notifyButton: TableSectionButton!
  
  private(set) var writeType: CBCharacteristicWriteType = .withoutResponse
  private(set) var characteristicItem: CBCharacteristic?
  weak var delegate: BluetoothCharacteristicActionCellDelegate?
  
  
  
  override open func awakeFromNib() {
    super.awakeFromNib()
    setup()
    setupStyle()
  }
}


// MARK: - ViewSetupable protocol
extension BluetoothCharacteristicActionTableViewCell: ViewSetupable {
  
  func setup() {
    selectionStyle = .none
  }
  
  
  func setupStyle() {
    setupBackground()
    setupButtons()
  }
  
}


// MARK: Configure cell
extension BluetoothCharacteristicActionTableViewCell {
  
  func configureWith(item: CBCharacteristic, at indexPath: IndexPath) {
    characteristicItem = item
    
    configSendButton(at: indexPath)
    configNotifyButton(at: indexPath)
    
    let characteristicProperties = item.getProperties()
    writeType = characteristicProperties.contains(.writeWithoutResponse) ? .withoutResponse : .withResponse
  }
  
  func hideSendButton() {
    sendButton.isHidden = true
  }
  
  func hideNotifyButton() {
    notifyButton.isHidden = true
  }
}


// MARK: Render
private extension BluetoothCharacteristicActionTableViewCell {
  
  func setupBackground() {
    alpha = 1
    backgroundColor = CharacteristicActionStyle.defaultBackgroundColor
  }
  
  func setupButtons() {
    sendButton.titleLabel?.font = CharacteristicActionStyle.actionButtonTitleFont
    notifyButton.titleLabel?.font = CharacteristicActionStyle.actionButtonTitleFont
  }
  
  func configSendButton(at indexPath: IndexPath) {
    guard let characteristicProperties = characteristicItem?.getProperties() else { return }
    let isContainWriteProperty = (characteristicProperties.contains(.write) || characteristicProperties.contains(.writeWithoutResponse))
    
    sendButton.setTitle(NSLocalizedString("BLUETOOTH_PERIPHERAL_CELL_BUTTON_SEND_TITLE", comment: ""), for: .normal)
    sendButton.isEnabled = isContainWriteProperty
    sendButton.indexPath = indexPath
  }
  
  func configNotifyButton(at indexPath: IndexPath) {
    guard let characteristicProperties = characteristicItem?.getProperties() else { return }
    let isContainNotifyProperty = characteristicProperties.contains(.notify)
    
    notifyButton.setTitle(NSLocalizedString("BLUETOOTH_PERIPHERAL_CELL_BUTTON_LISTEN_NOTIFICATIONS_TITLE", comment: ""), for: .normal)
    notifyButton.isEnabled = isContainNotifyProperty
    notifyButton.indexPath = indexPath
  }
}


// MARK: - ViewSetupable protocol
extension BluetoothCharacteristicActionTableViewCell {
  
  @IBAction func sendButtonPressed(_ sender: TableSectionButton) {
    do {
      try delegate?.bluetoothCharacteristicActionCell(self, didPressSend: sender)
    } catch let error as BluetoothError {
      BluetoothError.handle(error: error)
    } catch {
      BluetoothError.handle()
    }
    
  }
  
  @IBAction func notifyButtonPressed(_ sender: TableSectionButton) {
    do {
      try delegate?.bluetoothCharacteristicActionCell(self, didPressListenNotifications: sender)
    } catch let error as BluetoothError {
      BluetoothError.handle(error: error)
    } catch {
      BluetoothError.handle()
    }
  }
  
}
