//
//  UserInfoSettingsCellDelegate.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

protocol UserInfoSettingsCellDelegate: class {
  func userInfoSettingsCell(_ cell: UserInfoSettingsTableViewCell, didPressUserPickerButtonAt indexPath: IndexPath)
}
