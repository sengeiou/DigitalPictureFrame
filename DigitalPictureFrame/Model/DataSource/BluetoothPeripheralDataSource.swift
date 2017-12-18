//
//  BluetoothPeripheralDataSource.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth

final class BluetoothPeripheralDataSource: NSObject, BluetoothPeripheralDataSourceDelegate {
  fileprivate let sharedBluetoothManager = BluetoothManager.shared()
  
  var advertisementData: [String: Any]?
  var advertisementDataKeys: [String]?
  var showAdvertisementData = false
  var characteristicsDic = [CBUUID : [CBCharacteristic]]()
//  var delegateVC: BluetoothScanningCellDelegate
  
  
  init(advertisementData: [String: Any]?) {
//    self.delegateVC = delegateVC
    self.advertisementData = advertisementData
    self.advertisementDataKeys = ([String](advertisementData!.keys)).sorted()
  }
  
  
  func item(at indexPath: IndexPath) -> [String: Any]? {
//    return advertisementData?[indexPath.row]
    return nil
  }
}


// MARK: - UITableViewDataSource protocol
extension BluetoothPeripheralDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    print("numberOfSectionsInTableView:\(sharedBluetoothManager.connectedPeripheral!.services!.count + 1)")
    return sharedBluetoothManager.connectedPeripheral!.services!.count + 1
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      if showAdvertisementData {
        return advertisementDataKeys!.count
      } else {
        return 0
      }
    }
//    let characteristics = characteristicsDic[services![section - 1].uuid]
//    return characteristics == nil ? 0 : characteristics!.count
    return 0
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
    view.addConstraintsWith(format: "H:|-8-[view0]|", forView: titleLabel)
    view.addConstraintsWith(format: "V:|[view0]|", forView: titleLabel)
    return view
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let item = item(at: indexPath) else { return UITableViewCell() }
    
    let cell = tableView.dequeueReusableCell(withIdentifier: BluetoothScanningTableViewCell.reuseIdentifier, for: indexPath) as! BluetoothScanningTableViewCell
//    cell.configure(by: item, at: indexPath)
//    cell.delegate = delegateVC
    return cell
  }
  
}


// MARK: - UITableViewDelegate protocol
extension BluetoothPeripheralDataSource {
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 40
  }
  
}

