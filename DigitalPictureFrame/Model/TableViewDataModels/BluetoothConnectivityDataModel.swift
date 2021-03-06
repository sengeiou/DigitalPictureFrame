//
//  BluetoothConnectivityDataModel.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit

final class BluetoothConnectivityDataModel: NSObject, BluetoothConnectivityDataModelDelegate {
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
extension BluetoothConnectivityDataModel {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return numberOfRows
  }
  
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    typealias HeaderStyle = Style.BluetoothConnectivityTableViewHeader
    
    let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
    let titleLabel = UILabel(frame: .zero)
    titleLabel.font = HeaderStyle.titleLabelFont
    titleLabel.textColor = HeaderStyle.titleLabelTextColor
    titleLabel.textAlignment = HeaderStyle.titleLabelTextAlignment
    titleLabel.numberOfLines = HeaderStyle.titleLabelNumberOfLines
    titleLabel.text = NSLocalizedString("BLUETOOTH_SCANNING_TABLEVIEW_HEADER_TITLE", comment: "")
    
    view.backgroundColor = HeaderStyle.defaultBackgroundColor
    view.addSubview(titleLabel)
    
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    let titleLabelLeading = titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8)
    let titleLabelTrailing = titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
    let titleLabelTopConstraint = titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 0)
    let titleLabelBottomConstraint = titleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
    NSLayoutConstraint.activate([titleLabelLeading, titleLabelTrailing, titleLabelTopConstraint, titleLabelBottomConstraint])
    
    return view
  }
  

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let item = item(at: indexPath) else { return UITableViewCell() }
    
    let cell = tableView.dequeueReusableCell(withIdentifier: BluetoothScanningTableViewCell.reuseIdentifier, for: indexPath) as! BluetoothScanningTableViewCell
    cell.configureWith(item: item, at: indexPath)
    cell.delegate = delegateVC
    return cell
  }

}


// MARK: - UITableViewDelegate protocol
extension BluetoothConnectivityDataModel {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 65
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 40
  }
  
}
