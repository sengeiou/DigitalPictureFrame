//
//  BluetoothConnectivityDataSourceDelegate.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit

protocol BluetoothConnectivityDataSourceDelegate: class, UITableViewDataSource, UITableViewDelegate {
  var items: [PeripheralItem]? { get set }
  var delegateVC: BluetoothScanningCellDelegate { get set }
  
  func item(at indexPath: IndexPath) -> PeripheralItem?
}


extension BluetoothConnectivityDataSourceDelegate {
  
  var numberOfRowsInSection: Int {
    return items?.count ?? 0
  }
  
}
