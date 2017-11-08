//
//  UserInfoSettingsCellDelegate.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/7/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

protocol UserInfoSettingsCellDelegate: class {
  func userInfoSettingsCell(_ cell: UserInfoSettingsTableViewCell, didPressUserPickerButtonAt indexPath: IndexPath)
}
