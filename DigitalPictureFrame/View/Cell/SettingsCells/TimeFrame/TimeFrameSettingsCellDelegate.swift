//
//  TimeFrameSettingsCellDelegate.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/6/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit

protocol TimeFrameSettingsCellDelegate: class {
  func timeFrameSettingsCell(_ cell: TimeFrameSettingsTableViewCell, didPressTimePickerButtonAt indexPath: IndexPath)
}
