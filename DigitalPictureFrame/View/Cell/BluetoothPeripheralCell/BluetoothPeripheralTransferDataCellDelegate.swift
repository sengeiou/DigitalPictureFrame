//
//  BluetoothPeripheralTransferDataCellDelegate.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit

protocol BluetoothPeripheralTransferDataCellDelegate: class {
  func bluetoothPeripheralCell(_ bluetoothPeripheralCell: BluetoothPeripheralTransferDataTableViewCell, didPressSend button: PeripheralButton)
  func bluetoothPeripheralCell(_ bluetoothPeripheralCell: BluetoothPeripheralTransferDataTableViewCell, didPressListenNotifications button: PeripheralButton)
}
