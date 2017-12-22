//
//  BluetoothPeripheralDeviceInfoTableViewCell.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit
import CoreBluetooth

class BluetoothPeripheralDeviceInfoTableViewCell: UITableViewCell {
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var characteristicUUIDLabel: UILabel!
  @IBOutlet weak var propertiesDescriptionLabel: UILabel!
  
  
  var characteristicItem: CBCharacteristic? {
    didSet {
      guard let characteristicItem = characteristicItem else { return }
      nameLabel.text = characteristicItem.name
      characteristicUUIDLabel.text = characteristicItem.uuid.uuidString
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
extension BluetoothPeripheralDeviceInfoTableViewCell: ViewSetupable {
  
  func setup() {
    selectionStyle = .none
    nameLabel.text = ""
    characteristicUUIDLabel.text = ""
    propertiesDescriptionLabel.text = ""
  }
  
  
  func setupStyle() {
    typealias StyleDeviceInfoCell = Style.BluetoothPeripheralDeviceInfoCell
    backgroundColor = StyleDeviceInfoCell.defaultBackgroundColor
    nameLabel.font = StyleDeviceInfoCell.nameLabelFont
    nameLabel.textColor = StyleDeviceInfoCell.nameLabelTextColor
    nameLabel.textAlignment = StyleDeviceInfoCell.nameLabelAlignment
    nameLabel.numberOfLines = StyleDeviceInfoCell.nameLabelNumberOfLines
    
    characteristicUUIDLabel.font = StyleDeviceInfoCell.characteristicUUIDLabelFont
    characteristicUUIDLabel.textColor = StyleDeviceInfoCell.characteristicUUIDLabelTextColor
    characteristicUUIDLabel.textAlignment = StyleDeviceInfoCell.characteristicUUIDLabelAlignment
    characteristicUUIDLabel.numberOfLines = StyleDeviceInfoCell.characteristicUUIDLabelNumberOfLines
    
    propertiesDescriptionLabel.font = StyleDeviceInfoCell.propertiesDescriptionLabelFont
    propertiesDescriptionLabel.textColor = StyleDeviceInfoCell.propertiesDescriptionLabelTextColor
    propertiesDescriptionLabel.textAlignment = StyleDeviceInfoCell.propertiesDescriptionLabelAlignment
    propertiesDescriptionLabel.numberOfLines = StyleDeviceInfoCell.propertiesDescriptionLabelNumberOfLines
  }
  
}



// MARK: Configure cell
extension BluetoothPeripheralDeviceInfoTableViewCell {

  func configureWith(item: CBCharacteristic?, at indexPath: IndexPath) {
    characteristicItem = item
  }
}
