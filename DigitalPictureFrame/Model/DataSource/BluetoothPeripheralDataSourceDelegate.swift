//
//  BluetoothPeripheralDataSourceDelegate.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit

protocol BluetoothPeripheralDataSourceDelegate: class, UITableViewDataSource, UITableViewDelegate {
  var advertisementData: [String: Any]? { get set }
//  var delegateVC: BluetoothScanningCellDelegate { get set }
  
  func item(at indexPath: IndexPath) -> [String: Any]?
}


extension BluetoothPeripheralDataSourceDelegate {
  
  var numberOfRows: Int {
    return advertisementData?.count ?? 0
  }
  
}

