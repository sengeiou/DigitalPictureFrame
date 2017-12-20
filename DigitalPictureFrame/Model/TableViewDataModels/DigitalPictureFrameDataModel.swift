//
//  DigitalPictureFrameDataModel.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit

final class DigitalPictureFrameDataModel: NSObject, DigitalPictureFrameDataModelDelegate {
  var items: [DigitalPictureFrameItem]?
  var delegateVC: UIViewController
  
  
  init(_ delegateVC: UIViewController, items: [DigitalPictureFrameItem]?) {
    self.delegateVC = delegateVC
    self.items = items
  }
  
  
  func itemCount(in section: Int) -> Int {
    return items?[section].cells.count ?? 0
  }
  
  func item(at indexPath: IndexPath) -> DigitalPictureFrameItem? {
    return items?[indexPath.section]
  }
  
  func item(at section: Int) -> DigitalPictureFrameItem? {
    return items?[section]
  }
}


// MARK: - UITableViewDataSource protocol
extension DigitalPictureFrameDataModel {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return numberOfSections
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemCount(in: section)
  }
  
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    guard let frameItem = item(at: section) else { return nil }
    
    switch frameItem.section {
    case .general, .time, .userInfo, .zipCode:
      return frameItem.section.rawValue
      
    default:
      return nil
    }
    
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let frameItem = item(at: indexPath) else { return UITableViewCell() }
    let defaultCell = UITableViewCell()
    
    switch delegateVC {
    case is UserViewController where frameItem.type == .user:
      let cell = tableView.dequeueDigitalPictureFrameCell(cell: UserTableViewCell.self)
      cell.delegate = delegateVC as! UserViewController
      cell.configure(with: frameItem, at: indexPath)
      return cell
      
    case is SettingsViewController:
      switch frameItem.type {
      case .generalSettings:
        let cell = tableView.dequeueDigitalPictureFrameCell(cell: GeneralSettingsTableViewCell.self)
        cell.delegate = delegateVC as! SettingsViewController
        cell.configure(with: frameItem, at: indexPath)
        return cell
        
      case .timeFrameSettings:
        let cell = tableView.dequeueDigitalPictureFrameCell(cell: TimeFrameSettingsTableViewCell.self)
        cell.delegate = delegateVC as! SettingsViewController
        cell.configure(with: frameItem, at: indexPath)
        return cell
        
      case .userInfoSettings:
        let cell = tableView.dequeueDigitalPictureFrameCell(cell: UserInfoSettingsTableViewCell.self)
        cell.delegate = delegateVC as! SettingsViewController
        cell.configure(with: frameItem, at: indexPath)
        return cell
        
      case .weatherZipcodeSettings:
        let cell = tableView.dequeueDigitalPictureFrameCell(cell: WeatherZipcodeSettingsTableViewCell.self)
        cell.delegate = delegateVC as! SettingsViewController
        cell.configure(with: frameItem, at: indexPath)
        return cell
        
      default:
        return defaultCell
      }
      
    case is WiFiViewController where frameItem.type == .wifi:
      let cell = tableView.dequeueDigitalPictureFrameCell(cell: WiFiTableViewCell.self)
      cell.delegate = delegateVC as! WiFiViewController
      cell.configure(with: frameItem, at: indexPath)
      return cell
      
    default:
      return defaultCell
    }
  }
  
}


// MARK: - UITableViewDelegate protocol
extension DigitalPictureFrameDataModel {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 65
  }

}
