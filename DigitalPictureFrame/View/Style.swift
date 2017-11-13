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

}




