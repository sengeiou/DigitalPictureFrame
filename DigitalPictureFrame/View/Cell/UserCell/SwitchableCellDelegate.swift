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
