//
//  UserCellDelegate.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/7/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit

protocol UserCellDelegate: class {
  func userCell(_ cell: UserTableViewCell, didPressSwitch button: UISwitch, at indexPath: IndexPath)
}
