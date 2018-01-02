//
//  BluetoothPeripheralDeviceInfoTableViewCell.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit
import CoreBluetooth

class BluetoothCharacteristicTableViewCell: UITableViewCell {
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var propertiesDescriptionLabel: UILabel!
  
  
  var characteristicItem: CBCharacteristic? {
    didSet {
      guard let characteristicItem = characteristicItem else { return }
      nameLabel.text = characteristicItem.name
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
extension BluetoothCharacteristicTableViewCell: ViewSetupable {
  
  func setup() {
    selectionStyle = .none
    accessoryType = .disclosureIndicator
    nameLabel.text = ""
    propertiesDescriptionLabel.text = ""
  }
  
  
  func setupStyle() {
    typealias CharacteristicStyle = Style.BluetoothCharacteristicCell
    backgroundColor = CharacteristicStyle.defaultBackgroundColor
    nameLabel.font = CharacteristicStyle.nameLabelFont
    nameLabel.textColor = CharacteristicStyle.nameLabelTextColor
    nameLabel.textAlignment = CharacteristicStyle.nameLabelAlignment
    nameLabel.numberOfLines = CharacteristicStyle.nameLabelNumberOfLines
    
    propertiesDescriptionLabel.font = CharacteristicStyle.propertiesDescriptionLabelFont
    propertiesDescriptionLabel.textColor = CharacteristicStyle.propertiesDescriptionLabelTextColor
    propertiesDescriptionLabel.textAlignment = CharacteristicStyle.propertiesDescriptionLabelAlignment
    propertiesDescriptionLabel.numberOfLines = CharacteristicStyle.propertiesDescriptionLabelNumberOfLines
  }
  
}



// MARK: Configure cell
extension BluetoothCharacteristicTableViewCell {

  func configureWith(item: CBCharacteristic?, at indexPath: IndexPath) {
    characteristicItem = item
  }
}
