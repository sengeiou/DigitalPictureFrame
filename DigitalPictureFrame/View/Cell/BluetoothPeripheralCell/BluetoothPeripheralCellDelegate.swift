//
//  BluetoothPeripheralCellDelegate.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit

protocol BluetoothPeripheralCellDelegate: class {
  func bluetoothPeripheralCell(_ bluetoothPeripheralCell: BluetoothPeripheralTableViewCell, didPressSend button: UIButton)
  func bluetoothPeripheralCell(_ bluetoothPeripheralCell: BluetoothPeripheralTableViewCell, didPressListenNotifications button: UIButton)
}
