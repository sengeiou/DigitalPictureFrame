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
  @IBOutlet weak var serviceCounterLabel: UILabel!
  @IBOutlet weak var signalStrengthLabel: UILabel!
  @IBOutlet weak var connectButton: TableSectionButton!
  
  weak var delegate: BluetoothScanningCellDelegate?
  
  private var peripheral: PeripheralItem? {
    didSet {
      guard let peripheral = peripheral else { return }
      signalStrengthImageView.image = peripheral.signalStrengthIcon
      peripheralNameLabel.text = peripheral.name
      
      if let serviceUUIDs = peripheral.advertisementData["kCBAdvDataServiceUUIDs"] as? NSArray, serviceUUIDs.count > 0 {
        let counter = serviceUUIDs.count
        let stringFromFormat = String(format: NSLocalizedString("BLUETOOTH_SCANNING_CELL_SERVICE_COUNTER", comment: ""), counter)
        serviceCounterLabel.text = stringFromFormat + (counter > 1 ? "s" : "")
        
      } else {
        serviceCounterLabel.text = NSLocalizedString("BLUETOOTH_SCANNING_CELL_NO_SERVICE_COUNTER", comment: "")
      }

      
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
    
    alpha = 1.0
    selectionStyle = .none
    backgroundColor = StyleBluetoothScanningCell.defaultBackgroundColor
    
    peripheralNameLabel.font = StyleBluetoothScanningCell.peripheralNameLabelFont
    peripheralNameLabel.textColor = StyleBluetoothScanningCell.peripheralNameLabelTextColor
    peripheralNameLabel.textAlignment = StyleBluetoothScanningCell.peripheralNameLabelAlignment
    peripheralNameLabel.numberOfLines = StyleBluetoothScanningCell.peripheralNameLabelNumberOfLines
    
    serviceCounterLabel.font = StyleBluetoothScanningCell.serviceDescriptionLabelFont
    serviceCounterLabel.textAlignment = StyleBluetoothScanningCell.serviceDescriptionLabelAlignment
    serviceCounterLabel.numberOfLines = StyleBluetoothScanningCell.serviceDescriptionLabelNumberOfLines
    
    signalStrengthLabel.font = StyleBluetoothScanningCell.signalStrengthLabelFont
    signalStrengthLabel.textAlignment = StyleBluetoothScanningCell.signalStrengthLabelAlignment
    signalStrengthLabel.numberOfLines = StyleBluetoothScanningCell.signalStrengthLabelNumberOfLines

    signalStrengthImageView.backgroundColor = StyleBluetoothScanningCell.defaultBackgroundColor
    
    connectButton.setTitleColor(.red, for: .highlighted)
    connectButton.setTitleColor(.red, for: .selected)
    connectButton.titleLabel?.font = StyleBluetoothScanningCell.connectButtonTitleFont
    connectButton.layer.borderColor = UIColor.appleBlue.cgColor
    connectButton.layer.borderWidth = 0.5
    connectButton.layer.cornerRadius = 8
  }
  
}


// MARK: Configure cell
extension BluetoothScanningTableViewCell {
  
  func configureWith(item: PeripheralItem, at indexPath: IndexPath) {
    peripheral = item
    connectButton.indexPath = indexPath
    connectButton.isEnabled = true
    connectButton.setTitle(NSLocalizedString("BLUETOOTH_SCANNING_CELL_BUTTON_CONNECT_TITLE", comment: ""), for: .normal)
  }

}


// MARK: Actions
extension BluetoothScanningTableViewCell {
  
  @IBAction func connectButtonPressed(_ sender: TableSectionButton) {
    self.delegate?.bluetoothScanningCell(self, didPressConnect: sender)
  }
  
}
