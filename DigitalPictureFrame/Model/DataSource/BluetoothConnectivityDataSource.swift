//
//  BluetoothConnectivityDataSource.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

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
  
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
    let titleLabel = UILabel(frame: .zero)
    titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
    titleLabel.text = "Peripherals nearby"
    
    view.backgroundColor = UIColor.groupGray
    view.addSubview(titleLabel)
    view.addConstraintsWith(format: "H:|-8-[view0]|", forView: titleLabel)
    view.addConstraintsWith(format: "V:|[view0]|", forView: titleLabel)
    return view
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
    return 60
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 40
  }
  
}
