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
  typealias StyleDeviceInfoCell = Style.BluetoothPeripheralDeviceInfoCell
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  
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
  }
  
  
  func setupStyle() {
    backgroundColor = StyleDeviceInfoCell.defaultBackgroundColor
    setupLabels()
  }
  
}


// MARK: Render
private extension BluetoothPeripheralDeviceInfoTableViewCell {
  
  func setupLabels() {
    nameLabel.font = StyleDeviceInfoCell.nameLabelFont
    nameLabel.textColor = StyleDeviceInfoCell.nameLabelTextColor
    nameLabel.textAlignment = StyleDeviceInfoCell.nameLabelAlignment
    nameLabel.numberOfLines = StyleDeviceInfoCell.nameLabelNumberOfLines
    
    descriptionLabel.font = StyleDeviceInfoCell.descriptionLabelFont
    descriptionLabel.textColor = StyleDeviceInfoCell.descriptionLabelTextColor
    descriptionLabel.textAlignment = StyleDeviceInfoCell.descriptionLabelAlignment
    descriptionLabel.numberOfLines = StyleDeviceInfoCell.descriptionLabelNumberOfLines
  }
}


// MARK: Configure cell
extension BluetoothPeripheralDeviceInfoTableViewCell {

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
    nameLabel.text = item?.name
    descriptionLabel.text = getPropertiesFromArray((item?.getProperties())!)
  }
}
