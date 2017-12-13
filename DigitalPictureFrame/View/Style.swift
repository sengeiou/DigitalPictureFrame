//
//  Style.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit

struct Style {

  // MARK: - AvailabilityMessageView
  struct AvailabilityMessageView {
    static let titleLabelTextAlignment = NSTextAlignment.center
    static let titleLabelFont = UIFont.systemFont(ofSize: 20, weight: .bold)
    
    static let subTitleLabelFont = UIFont.systemFont(ofSize: 15, weight: .light)
    static let subTitleLabelTextAlignment = NSTextAlignment.center
  }
  
  // MARK: - TimePickerView
  struct TimePickerView {
    static var itemNameLabelFont = UIFont.systemFont(ofSize: 18, weight: .regular)
    
    static var pickerItemLabelFont = UIFont.systemFont(ofSize: 18, weight: .light)
    static var pickerItemLabelTextAlignment = NSTextAlignment.center
    static var pickerItemLabelLineBreakMode = NSLineBreakMode.byWordWrapping
    static var pickerItemLabelNumberOfLines = 0
  }

  
  // MARK: - BluetoothConnectivityVC
  struct BluetoothConnectivityVC {
    static let buttonTitleFont = UIFont.systemFont(ofSize: 23, weight: .bold)
    
    static let connectivityTitleLabelFont = UIFont.systemFont(ofSize: 17, weight: .light)
    static let connectivityTitleLabelNumberOfLines = 1
    static let connectivityTitleLabelAlignment = NSTextAlignment.center
    
    static let centralManagerStateLabelFont = UIFont.systemFont(ofSize: 13, weight: .light)
    static let centralManagerStateLabelNumberOfLines = 2
    static let centralManagerStateLabelAlignment = NSTextAlignment.center
  }
  
  
  // MARK: - BluetoothScanningTableViewCell
  struct BluetoothScanningCell {
    static let peripheralNameFont = UIFont.systemFont(ofSize: 15, weight: .regular)
    static let connectButtonTitleFont = UIFont.systemFont(ofSize: 13, weight: .medium)
  }
}
