//
//  BluetoothConnectivityDataSource.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit

final class BluetoothConnectivityDataSource: NSObject, BluetoothConnectivityDataSourceDelegate {
  var items: [BluetoothItem]?
  var delegateVC: UIViewController
  
  
  init(_ delegateVC: UIViewController, items: [BluetoothItem]?) {
    self.delegateVC = delegateVC
    self.items = items
  }
  
  
  func item(at indexPath: IndexPath) -> BluetoothItem? {
    return items?[indexPath.row]
  }
}


// MARK: - UITableViewDataSource protocol
extension BluetoothConnectivityDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return numberOfRowsInSection
  }
  
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Devices"
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return UITableViewCell()
  }
  
}


// MARK: - UITableViewDelegate protocol
extension BluetoothConnectivityDataSource {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 55
  }
  
}
