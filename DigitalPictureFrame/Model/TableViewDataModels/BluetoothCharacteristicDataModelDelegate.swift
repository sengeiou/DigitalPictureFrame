//
//  BluetoothCharacteristicDataModelDelegate.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth

protocol BluetoothCharacteristicDataModelDelegate: class, UITableViewDataSource, UITableViewDelegate {
  var delegateVC: BluetoothCharacteristicActionCellDelegate { get }
  var characteristicItem: CBCharacteristic { get set }
  var properties: [CharacteristicPropertyType] { get }
  var sectionHeaderTitles: [String] { get }
  
  init(_ delegateVC: BluetoothCharacteristicActionCellDelegate, characteristicItem: CBCharacteristic)
}
