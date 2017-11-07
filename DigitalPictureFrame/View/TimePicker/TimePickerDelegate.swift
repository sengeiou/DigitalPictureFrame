//
//  TimePickerDelegate.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/6/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit

protocol TimePickerDelegate: class {
  func timePicker(_ timePicker: TimePicker, didSelectTime sender: UIDatePicker)
  func timePicker(_ timePicker: TimePicker, didPressDone sender: UIDatePicker)
  func timePicker(_ timePicker: TimePicker, didPressCancel sender: UIDatePicker)
}
