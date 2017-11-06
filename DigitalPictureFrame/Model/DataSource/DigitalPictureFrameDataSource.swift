//
//  DigitalPictureFrameDataSource.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/3/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit

final class DigitalPictureFrameDataSource: NSObject, DigitalPictureFrameDataSourceDelegate {
  var items: [DigitalPictureFrameItem]
  
  init(items: [DigitalPictureFrameItem]) {
    self.items = items
  }
  
  
  func itemCount(in section: Int) -> Int {
    return items[section].cells.count
  }
  
  func item(at indexPath: IndexPath) -> DigitalPictureFrameItem {
    return items[indexPath.section]
  }
  
  func item(at section: Int) -> DigitalPictureFrameItem {
    return items[section]
  }
}


// MARK: - UITableViewDataSource protocol
extension DigitalPictureFrameDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return items.count
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemCount(in: section)
  }
  
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    let frameItem = item(at: section)
    return frameItem.section.rawValue
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let frameItem = item(at: indexPath)
    
    switch frameItem.type {
    case .user:
      let cell = tableView.dequeueDigitalPictureFrameCell(cell: UserTableViewCell.self)
      cell.setup(by: frameItem, at: indexPath)
      return cell
      
    case .generalSettings:
      let cell = tableView.dequeueDigitalPictureFrameCell(cell: GeneralSettingsTableViewCell.self)
      cell.setup(by: frameItem, at: indexPath)
      return cell
      
    case .timeFrameSettings:
      let cell = tableView.dequeueDigitalPictureFrameCell(cell: TimeFrameSettingsTableViewCell.self)
      cell.setup(by: frameItem, at: indexPath)
      return cell
      
    case .userInfoSettings:
      let cell = tableView.dequeueDigitalPictureFrameCell(cell: UserInfoSettingsTableViewCell.self)
      cell.setup(by: frameItem, at: indexPath)
      return cell
      
    case .weatherZipcodeSettings:
      let cell = tableView.dequeueDigitalPictureFrameCell(cell: WeatherZipcodeSettingsTableViewCell.self)
      cell.setup(by: frameItem, at: indexPath)
      return cell
      
    case .wifi:
      let cell = tableView.dequeueDigitalPictureFrameCell(cell: WiFiTableViewCell.self)
      cell.setup(by: frameItem, at: indexPath)
      return cell
    }
  }
  
}


// MARK: - UITableViewDelegate protocol
extension DigitalPictureFrameDataSource {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let frameItem = item(at: indexPath)
    print("Row: \(indexPath.row) and type: \(frameItem.type.rawValue)")
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 65
  }
  
}
