//
//  ListPickerViewDelegate.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/6/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit

@objc protocol ListPickerViewDelegate: class {
  @objc optional func listPicker(_ listPicker: ListPickerView, didSelectTime sender: UIDatePicker)
  func listPicker(_ listPicker: ListPickerView, didPressDone sender: UIDatePicker)
  func listPicker(_ listPicker: ListPickerView, didPressCancel sender: UIDatePicker)
}
