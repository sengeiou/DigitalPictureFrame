//
//  TimePickerView+Actions.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Actions
extension TimePickerView {

  @IBAction func didPressCancel(_ sender: UIButton) {
    delegate?.timePicker(self, didPressCancel: picker)
  }
  
  @IBAction func didPressDone(_ sender: UIButton) {
    delegate?.timePicker(self, didPressDone: picker)
  }

}
