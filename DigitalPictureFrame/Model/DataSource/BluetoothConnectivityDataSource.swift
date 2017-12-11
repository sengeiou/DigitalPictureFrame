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
  var items: [PeripheralItem]?
  var delegateVC: BluetoothScanningCellDelegate
  
  
  init(_ delegateVC: BluetoothScanningCellDelegate, items: [PeripheralItem]?) {
    self.delegateVC = delegateVC
    self.items = items
  }
  
  
  func item(at indexPath: IndexPath) -> PeripheralItem? {
    return items?[indexPath.row]
  }
}


// MARK: - UITableViewDataSource protocol
extension BluetoothConnectivityDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return numberOfRowsInSection
  }
  
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "List of devices"
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let item = item(at: indexPath) else { return UITableViewCell() }
    
    let cell = tableView.dequeueReusableCell(withIdentifier: BluetoothScanningTableViewCell.reuseIdentifier) as! BluetoothScanningTableViewCell
    cell.configure(by: item, at: indexPath)
    cell.delegate = delegateVC
    return cell
  }
  
}


// MARK: - UITableViewDelegate protocol
extension BluetoothConnectivityDataSource {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }
  
}
