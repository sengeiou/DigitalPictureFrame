//
//  SwitchableCellDelegate.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit

protocol SwitchableCellDelegate: class {
  func switchableCell(_ cell: UITableViewCell, didPressSwitch button: UISwitch, at indexPath: IndexPath)
}


extension SwitchableCellDelegate where Self: PageContentViewController {
  
  func switchableCell(_ cell: UITableViewCell, didPressSwitch button: UISwitch, at indexPath: IndexPath) {
    guard let modifiedTimeFrameItem = dataSourceDelegate?.item(at: indexPath) else { return }
    let switchState = button.isOn
    
    let item = modifiedTimeFrameItem.cells[indexPath.row]
    item.value = switchState
  }
  
}
