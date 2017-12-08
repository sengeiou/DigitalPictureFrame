//
//  BluetoothConnectivityDelegate.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

protocol BluetoothScanningCellDelegate: class {
  func bluetoothScanningCell(_ bluetoothScanningCell: BluetoothScanningTableViewCell, didConnectPeripheral at: Int)
}
