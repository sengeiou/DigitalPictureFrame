//
//  WiFiCellDelegate.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

protocol WiFiCellDelegate: class {
  func wifiCell(_ cell: WiFiTableViewCell, didPressPasswordButtonAt indexPath: IndexPath)
}
