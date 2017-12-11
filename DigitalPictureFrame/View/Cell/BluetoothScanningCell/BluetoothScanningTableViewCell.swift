//
//  BluetoothScanningTableViewCell.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit

class BluetoothScanningTableViewCell: UITableViewCell {
  @IBOutlet weak var statusIcon: UIImageView!
  @IBOutlet weak var peripheralNameLabel: UILabel!
  @IBOutlet weak var connectButton: UIButton!
  
  weak var delegate: BluetoothScanningCellDelegate?
  
  private var peripheral: PeripheralItem? {
    didSet {
      guard let peripheral = peripheral else { return }
      statusIcon.image = peripheral.statusIcon
      peripheralNameLabel.text = peripheral.name
      connectButton.setTitle("Connect", for: .normal)
    }
  }
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setup()
    setupStyle()
  }
}


// MARK: - ViewSetupable protocol
extension BluetoothScanningTableViewCell: ViewSetupable {
  
  func setup() {
    
  }
  
  
  func setupStyle() {
    typealias StyleBluetoothScanningCell = Style.BluetoothScanningCell
    
    selectionStyle = .none
    peripheralNameLabel.font = StyleBluetoothScanningCell.peripheralNameFont
    connectButton.titleLabel?.font = StyleBluetoothScanningCell.connectButtonTitleFont
    connectButton.layer.borderColor = UIColor.appleBlue.cgColor
    connectButton.layer.borderWidth = 0.5
    connectButton.layer.cornerRadius = 8
  }
}


// MARK: Configure cell
extension BluetoothScanningTableViewCell {
  
  func configure(by item: PeripheralItem, at indexPath: IndexPath) {
    peripheral = item
    connectButton.tag = indexPath.row
  }
  
}


// MARK: Actions
extension BluetoothScanningTableViewCell {
  
  @IBAction func connectButtonPressed(_ sender: UIButton) {
    delegate?.bluetoothScanningCell(self, didPressConnect: sender)
  }
  
}
