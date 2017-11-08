//
//  SwitchableCellDelegate.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/7/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit

protocol SwitchableCellDelegate: class {
  func switchableCell(_ cell: UITableViewCell, didPressSwitch button: UISwitch, at indexPath: IndexPath)
}


extension SwitchableCellDelegate where Self: BaseViewController {
  
  func switchableCell(_ cell: UITableViewCell, didPressSwitch button: UISwitch, at indexPath: IndexPath) {
    guard let modifiedTimeFrameItem = dataSourceDelegate?.item(at: indexPath) else { return }
    let switchState = button.isOn
    
    let item = modifiedTimeFrameItem.cells[indexPath.row]
    item.value = switchState
    print("switchableCell at: \(indexPath.row)")
  }
  
}
