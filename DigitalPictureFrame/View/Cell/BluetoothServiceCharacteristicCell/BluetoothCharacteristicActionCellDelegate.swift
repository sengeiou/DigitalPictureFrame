//
//  BluetoothCharacteristicActionCellDelegate.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit

protocol BluetoothCharacteristicActionCellDelegate: class {
  func bluetoothCharacteristicActionCell(_ bluetoothCharacteristicActionCell: BluetoothCharacteristicActionTableViewCell, didPressSend button: TableShadowButton) throws
  func bluetoothCharacteristicActionCell(_ bluetoothCharacteristicActionCell: BluetoothCharacteristicActionTableViewCell, didPressListenNotifications button: TableShadowButton) throws
}
