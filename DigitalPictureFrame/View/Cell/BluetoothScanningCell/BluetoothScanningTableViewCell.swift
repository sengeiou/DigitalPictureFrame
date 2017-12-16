//
//  BluetoothScanningTableViewCell.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit

class BluetoothScanningTableViewCell: UITableViewCell {
  @IBOutlet weak var signalStrengthImageView: UIImageView!
  @IBOutlet weak var peripheralNameLabel: UILabel!
  @IBOutlet weak var connectButton: UIButton!
  @IBOutlet weak var signalStrengthLabel: UILabel!
  
  weak var delegate: BluetoothScanningCellDelegate?
  
  private var peripheral: PeripheralItem? {
    didSet {
      guard let peripheral = peripheral else { return }
      signalStrengthImageView.image = peripheral.signalStrengthIcon
      peripheralNameLabel.text = peripheral.name
      
      let RSSI = Int(peripheral.RSSI)
      signalStrengthLabel.text = "\(RSSI)"
      
      switch labs(RSSI) {
      case 0...40:
        signalStrengthImageView.image = UIImage(named: "icon-signal-strength-5")
        
      case 41...53:
        signalStrengthImageView.image = UIImage(named: "icon-signal-strength-4")
        
      case 54...65:
        signalStrengthImageView.image = UIImage(named: "icon-signal-strength-3")
        
      case 66...77:
        signalStrengthImageView.image = UIImage(named: "icon-signal-strength-2")
        
      case 77...89:
        signalStrengthImageView.image = UIImage(named: "icon-signal-strength-1")
        
      default:
        signalStrengthImageView.image = UIImage(named: "icon-signal-strength-0")
      }
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
    connectButton.setTitle(NSLocalizedString("BLUETOOTH_SCANNING_CELL_BUTTON_CONNECT_TITLE", comment: ""), for: .normal)
    connectButton.isEnabled = true
  }
  
  
  func setupStyle() {
    typealias StyleBluetoothScanningCell = Style.BluetoothScanningCell
    
    selectionStyle = .none
    signalStrengthLabel.font = StyleBluetoothScanningCell.signalStrengthFont
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
    connectButton.isEnabled = true
    connectButton.setTitle(NSLocalizedString("BLUETOOTH_SCANNING_CELL_BUTTON_CONNECT_TITLE", comment: ""), for: .normal)
  }
  
  
  func configureConnectedButton() {
    connectButton.setTitle(NSLocalizedString("BLUETOOTH_SCANNING_CELL_BUTTON_CONNECTED_TITLE", comment: ""), for: .normal)
    connectButton.isEnabled = false
  }
  
}


// MARK: Actions
extension BluetoothScanningTableViewCell {
  
  @IBAction func connectButtonPressed(_ sender: UIButton) {
    delegate?.bluetoothScanningCell(self, didPressConnect: sender)
  }
  
}
