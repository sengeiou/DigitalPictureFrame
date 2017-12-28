//
//  BluetoothCharacteristicDataModel.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth

final class BluetoothCharacteristicDataModel: NSObject, BluetoothCharacteristicDataModelDelegate {
  var delegateVC: BluetoothCharacteristicActionCellDelegate
  var characteristicItem: CBCharacteristic
  var properties: [CharacteristicPropertyType]
  var sectionHeaderTitles: [String] {
    var headers = [String]()
    
    func checkAndAppendHeader(forProperty property: CharacteristicPropertyType) {
      if properties.contains(property) {
        let wirteProperty = properties.first { $0 == property }
        let header = wirteProperty?.description.uppercased() ?? ""
        headers.append(header)
      }
    }
    
    checkAndAppendHeader(forProperty: .notify)
    checkAndAppendHeader(forProperty: .indicate)
    checkAndAppendHeader(forProperty: .write)
    checkAndAppendHeader(forProperty: .writeWithoutResponse)
    headers.append("DESCRIPTORS")
    headers.append("PROPERTIES")
    return headers
  }
  
  
  init(_ delegateVC: BluetoothCharacteristicActionCellDelegate, characteristicItem: CBCharacteristic) {
    self.delegateVC = delegateVC
    self.characteristicItem = characteristicItem
    self.properties = characteristicItem.getProperties()
  }
}


// MARK: - UITableViewDataSource protocol
extension BluetoothCharacteristicDataModel {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == properiesSection {
      return properties.count
      
    } else if let descriptor = characteristicItem.descriptors, section == descriptorsSection {
      return descriptor.count
      
    } else if isWriteSection(at: section) || isNotifySection(at: section) {
      return 1
    }
    
    return 0
  }
  
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return sectionHeaderTitles.count
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if isWriteSection(at: indexPath.section), BluetoothManager.shared().connected  {
      let cell = tableView.dequeueReusableCell(withIdentifier: BluetoothCharacteristicActionTableViewCell.reuseIdentifier, for: indexPath) as! BluetoothCharacteristicActionTableViewCell
      
      cell.configureWith(item: characteristicItem, at: indexPath)
      cell.hideNotifyButton()
      cell.delegate = delegateVC

      return cell
    
    } else if isNotifySection(at: indexPath.section), BluetoothManager.shared().connected  {
      let cell = tableView.dequeueReusableCell(withIdentifier: BluetoothCharacteristicActionTableViewCell.reuseIdentifier, for: indexPath) as! BluetoothCharacteristicActionTableViewCell
      
      cell.configureWith(item: characteristicItem, at: indexPath)
      cell.hideSendButton()
      cell.delegate = delegateVC
      
      return cell
      
    } else {
      let properityCellIdentifier = "CharacteristicsProperityCellIdentifier"
      let cell = tableView.dequeueReusableCell(withIdentifier: properityCellIdentifier)
      cell?.selectionStyle = .none
      
      if indexPath.section == properiesSection {
        cell?.textLabel?.text = properties[indexPath.row].description
        
      } else if let descriptor = characteristicItem.descriptors, indexPath.section == descriptorsSection {
        cell?.textLabel?.text = descriptor[indexPath.row].uuid.description
      }
      return cell!
    }
  }
  
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    typealias BluetoothPeripheralHeaderStyle = Style.BluetoothPeripheralHeader
    let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 45))
    view.backgroundColor = UIColor.groupGray
    
    let titleLabel = UILabel(frame: .zero)
    titleLabel.text = sectionHeaderTitles[section]
    titleLabel.font = BluetoothPeripheralHeaderStyle.titleLabelFont
    titleLabel.textColor = BluetoothPeripheralHeaderStyle.titleLabelTextColor
    titleLabel.textAlignment = BluetoothPeripheralHeaderStyle.titleLabelAlignment
    titleLabel.numberOfLines = BluetoothPeripheralHeaderStyle.titleLabelNumberOfLines
    
    view.addSubview(titleLabel)
    view.addConstraintsWith(format: "H:|-8-[view0]|", forView: titleLabel)
    view.addConstraintsWith(format: "V:|[view0]|", forView: titleLabel)
    return view
  }
  
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return BluetoothPeripheralSectionType.sectionHeaderHeight
  }
  
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return BluetoothPeripheralSectionType.sectionCellHeight - 15
  }
  
}


// MARK: - Properies sections
private extension BluetoothCharacteristicDataModel {
  
  var properiesSection: Int {
    return sectionHeaderTitles.count - 1
  }
  
  var descriptorsSection: Int {
    return sectionHeaderTitles.count - 2
  }
  
  func isWriteSection(at section: Int) -> Bool {
    let sectionTitle = CharacteristicPropertyType.write.description.uppercased()
    return sectionHeaderTitles[section].contains(sectionTitle)
  }
  
  func isNotifySection(at section: Int) -> Bool {
    let sectionTitle = CharacteristicPropertyType.notify.description.uppercased()
    return sectionHeaderTitles[section].contains(sectionTitle)
  }
}
