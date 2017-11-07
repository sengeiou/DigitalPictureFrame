//
//  TimePicker+Actions.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/6/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Actions
extension TimePicker {
  
  @IBAction func didPressCancel(_ sender: UIButton) {
    delegate?.timePicker(self, didPressCancel: datePicker)
  }
  
  @IBAction func didPressDone(_ sender: UIButton) {
    delegate?.timePicker(self, didPressDone: datePicker)
  }
  
  @objc func timeDidChange(_ sender: UIDatePicker) {
    delegate?.timePicker?(self, didSelectTime: sender)
  }
  
}
