//
//  BluetoothPeripheralDataModel.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth

final class BluetoothPeripheralDataModel: NSObject, BluetoothPeripheralDataModelDelegate {
  private var advertisementData: [String: Any]?
  var peripheralServiceItem: PeripheralServiceItem?
  
  
  init(peripheralServiceItem: PeripheralServiceItem?) {
    self.peripheralServiceItem = peripheralServiceItem
    self.advertisementData = peripheralServiceItem?.advertisementData
  }
  
  
  func service(at section: Int) -> CBService? {
    guard section > 0 else { return nil }
    return peripheralServices?[section - 1]
  }
  
}


// MARK: - UITableViewDataSource protocol
extension BluetoothPeripheralDataModel {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    guard let numberOfServices = peripheralServices?.count else { return 0 }
    return numberOfServices + 1
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let peripheralSection = BluetoothPeripheralSectionType(rawValue: section), peripheralSection == .advertisementData {
      return peripheralServiceItem?.advertisementDataTypes?.count ?? 0
      
    } else if let service = service(at: section), let characteristics = peripheralServiceItem?.characteristics[service.uuid] {
      return characteristics.count
    }
    
    return 0
  }
  
  
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    typealias BluetoothPeripheralHeaderStyle = Style.BluetoothPeripheralHeader
    let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 45))
    view.backgroundColor = UIColor.groupGray
    
    let titleLabel = UILabel(frame: .zero)
    titleLabel.text = ""
    titleLabel.font = BluetoothPeripheralHeaderStyle.titleLabelFont
    titleLabel.textColor = BluetoothPeripheralHeaderStyle.titleLabelTextColor
    titleLabel.textAlignment = BluetoothPeripheralHeaderStyle.titleLabelAlignment
    titleLabel.numberOfLines = BluetoothPeripheralHeaderStyle.titleLabelNumberOfLines
    
    view.addSubview(titleLabel)
    view.addConstraintsWith(format: "H:|-8-[view0]|", forView: titleLabel)
    view.addConstraintsWith(format: "V:|[view0]|", forView: titleLabel)
    
    if let peripheralSection = BluetoothPeripheralSectionType(rawValue: section), peripheralSection == .advertisementData {
      titleLabel.text = NSLocalizedString("BLUETOOTH_PERIPHERAL_ADVERTISEMENT_SECTION_TITLE", comment: "")
      
    } else if let service = service(at: section) {
      titleLabel.text = service.characteristicName
    }
    
    return view
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let section = indexPath.section
    let row = indexPath.row
    
    if let peripheralServiceItem = peripheralServiceItem, let peripheralSection = BluetoothPeripheralSectionType(rawValue: section), peripheralSection == .advertisementData {
      let cell = tableView.dequeueReusableCell(withIdentifier: BluetoothPeripheralAdvertisementTableViewCell.reuseIdentifier) as! BluetoothPeripheralAdvertisementTableViewCell
      cell.configureWith(item: peripheralServiceItem, at: indexPath)
      return cell
      
    } else if let service = service(at: section), let characteristic = peripheralServiceItem?.characteristics[service.uuid]?[row] {
      let cell = tableView.dequeueReusableCell(withIdentifier: BluetoothCharacteristicTableViewCell.reuseIdentifier) as! BluetoothCharacteristicTableViewCell
      cell.configureWith(item: characteristic, at: indexPath)
      return cell
    }

    return UITableViewCell()
  }
}


// MARK: - UITableViewDelegate protocol
extension BluetoothPeripheralDataModel {
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return BluetoothPeripheralSectionType.sectionHeaderHeight
  }
  
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return BluetoothPeripheralSectionType.sectionCellHeight
  }
  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let service = service(at: indexPath.section), let characteristic = peripheralServiceItem?.characteristics[service.uuid]?[indexPath.row] else { return } 
    let notificationName = NotificationName.presentCharacteristicViewController.name
    let userInfo = [NotificationUserInfoKey.peripheralCharacteristic.rawValue: characteristic]
    
    NotificationCenter.default.post(name: notificationName, object: nil, userInfo: userInfo)
  }
  
}
