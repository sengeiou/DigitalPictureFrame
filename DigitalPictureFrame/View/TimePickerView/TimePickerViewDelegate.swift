//
//  TimePickerViewDelegate.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit

protocol TimePickerViewDelegate: class {
  func timePicker(_ timePickerView: TimePickerView, didPressDone sender: UIDatePicker)
  func timePicker(_ timePickerView: TimePickerView, didPressCancel sender: UIDatePicker)
}
