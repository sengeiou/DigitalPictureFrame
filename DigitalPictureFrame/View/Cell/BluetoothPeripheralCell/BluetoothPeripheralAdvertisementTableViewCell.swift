//
//  BluetoothPeripheralAdvertisementTableViewCell.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit

class BluetoothPeripheralAdvertisementTableViewCell: UITableViewCell {
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setup()
    setupStyle()
  }
  
}



// MARK: - ViewSetupable protocol
extension BluetoothPeripheralAdvertisementTableViewCell: ViewSetupable {
  
  func setup() {
    nameLabel.text = ""
    descriptionLabel.text = ""
    selectionStyle = .none
    accessoryType = .none
  }
  
  func setupStyle() {
    typealias StyleBluetoothAdvertisementCell = Style.BluetoothPeripheralAdvertisementCell

    backgroundColor = StyleBluetoothAdvertisementCell.defaultBackgroundColor
    nameLabel.font = StyleBluetoothAdvertisementCell.nameLabelFont
    nameLabel.textColor = StyleBluetoothAdvertisementCell.nameLabelTextColor
    nameLabel.textAlignment = StyleBluetoothAdvertisementCell.nameLabelAlignment
    nameLabel.numberOfLines = StyleBluetoothAdvertisementCell.nameLabelNumberOfLines
    
    descriptionLabel.font = StyleBluetoothAdvertisementCell.descriptionLabelFont
    descriptionLabel.textColor = StyleBluetoothAdvertisementCell.descriptionLabelTextColor
    descriptionLabel.textAlignment = StyleBluetoothAdvertisementCell.descriptionLabelAlignment
    descriptionLabel.numberOfLines = StyleBluetoothAdvertisementCell.descriptionLabelNumberOfLines
  }
  
}



// MARK: Configure cell
extension BluetoothPeripheralAdvertisementTableViewCell {
  
  func configureWith(item: CharacteristicServiceItem, at indexPath: IndexPath) {
    let advertisementData = item.advertisementData
    let item = item.advertisementDataTypes![indexPath.row]
    
    nameLabel.text = item.description
    descriptionLabel.text = item.getStringValue(from: advertisementData!)
  }
  
}
