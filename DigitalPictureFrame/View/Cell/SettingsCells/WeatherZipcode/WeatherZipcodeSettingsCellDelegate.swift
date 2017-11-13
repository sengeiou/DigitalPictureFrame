//
//  WeatherZipcodeSettingsCellDelegate.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

protocol WeatherZipcodeSettingsCellDelegate: class {
  func weatherZipcodeSettingsCell(_ cell: WeatherZipcodeSettingsTableViewCell, didPressZipcodeButtonAt indexPath: IndexPath)
}
