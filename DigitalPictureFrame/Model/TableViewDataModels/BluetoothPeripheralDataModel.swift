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
  var delegatorVC: BluetoothPeripheralCellDelegate
  var characteriticServiceItem: CharacteristicServiceItem?
  
  
  init(_ delegatorVC: BluetoothPeripheralCellDelegate, characteriticServiceItem: CharacteristicServiceItem?) {
    self.delegatorVC = delegatorVC
    self.characteriticServiceItem = characteriticServiceItem
    self.advertisementData = characteriticServiceItem?.advertisementData
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
    guard section == 0 else {
      if let service = service(at: section), let characteristics = characteriticServiceItem?.characteristics[service.uuid] {
        return characteristics.count
      }
      
      return 0
    }

    return characteriticServiceItem?.advertisementDataTypes?.count ?? 0
  }


  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 45))
    view.backgroundColor = UIColor.groupGray
    
    let serviceNameLabel = UILabel(frame: .zero)
    serviceNameLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    serviceNameLabel.textColor = .black
    serviceNameLabel.textAlignment = .left
    serviceNameLabel.numberOfLines = 1
    
    view.addSubview(serviceNameLabel)
    view.addConstraintsWith(format: "H:|-8-[view0]|", forView: serviceNameLabel)
    view.addConstraintsWith(format: "V:|[view0]|", forView: serviceNameLabel)
    
    if section == 0 {
      serviceNameLabel.text = NSLocalizedString("BLUETOOTH_PERIPHERAL_ADVERTISEMENT_SECTION_TITLE", comment: "")
    } else {
      if let service = service(at: section) {
        serviceNameLabel.text = service.characteristicName
      } else {
        serviceNameLabel.text = ""
      }
    }
    
    return view
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let section = indexPath.section
    let row = indexPath.row
    
    if section == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: BluetoothPeripheralAdvertisementTableViewCell.reuseIdentifier) as! BluetoothPeripheralAdvertisementTableViewCell
      cell.configureWith(item: characteriticServiceItem!, at: indexPath)
      return cell
      
    } else if let service = service(at: section), let characteristic = characteriticServiceItem?.characteristics[service.uuid]?[row], section == 1 {
      let cell = tableView.dequeueReusableCell(withIdentifier: BluetoothPeripheralDeviceInfoTableViewCell.reuseIdentifier) as! BluetoothPeripheralDeviceInfoTableViewCell
      cell.configureWith(item: characteristic, at: indexPath)
      return cell
      
    } else if let service = service(at: section), let characteristic = characteriticServiceItem?.characteristics[service.uuid]?[row] {
      let cell = tableView.dequeueReusableCell(withIdentifier: BluetoothPeripheralTableViewCell.reuseIdentifier) as! BluetoothPeripheralTableViewCell
      cell.configureWith(item: characteristic, at: indexPath)
      return cell
    }
    
    return UITableViewCell()
  }
  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard indexPath.section > 0 else { return }
    
    print("Click at section: \(indexPath.section), row: \(indexPath.row)")
//    let controller = CharacteristicController()
//    controller.characteristic = characteristicsDic[services![indexPath.section - 1].uuid]![indexPath.row]
//    self.navigationController?.pushViewController(controller, animated: true)
  }
}


// MARK: - UITableViewDelegate protocol
extension BluetoothPeripheralDataModel {
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 45
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    guard indexPath.section == 0 || indexPath.section == 1 else { return 110 }
    return 50
  }
  
}
