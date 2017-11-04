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
//  var items: [DigitalPictureFrameItem]
  var items: [String]
  
  init(items: [String]) {
    self.items = items
  }
  
  
  func itemCount(in section: Int) -> Int {
//    return items[section].cells.count
    return 0
  }
  
  func item(at indexPath: IndexPath) -> String {
//    return items[indexPath.section]
    return ""
  }
  
  func item(at section: Int) -> String {
//    return items[section]
    return ""
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
  
//  
//  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//    let frameItem = item(at: section)
//    return frameItem.section.rawValue
//  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return UITableViewCell()
//    let frameItem = item(at: indexPath)
//
//    switch frameItem.type {
//    case .imageDescriptionSwitch:
//      let cell = tableView.dequeueDigitalPictureFrameCell(cell: ImageDescriptionSwitchTableViewCell.self)
//      cell.setup(by: frameItem, at: indexPath)
//      return cell
//
//    case .imageDescriptionRightText:
//      let cell = tableView.dequeueDigitalPictureFrameCell(cell: ImageDescriptionRightTextTableViewCell.self)
//      cell.setup(by: frameItem, at: indexPath)
//      return cell
//    }
  }
  
}


// MARK: - UITableViewDelegate protocol
extension DigitalPictureFrameDataSource {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    let frameItem = item(at: indexPath)
//    print("Row: \(indexPath.row) and type: \(frameItem.type.rawValue)")
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 65
  }
  
}
