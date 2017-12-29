//
//  BluetoothScanningCellDelegate.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit

protocol BluetoothScanningCellDelegate: class {
  func bluetoothScanningCell(_ bluetoothScanningCell: BluetoothScanningTableViewCell, didPressConnect button: TableShadowButton)
}
