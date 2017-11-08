//
//  UserPickerView+Actions.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/8/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit

extension UserPickerView {
  
  @IBAction func didPressCancel(_ sender: UIButton) {
    delegate?.userPicker(self, didPressCancel: picker)
  }
  
  @IBAction func didPressDone(_ sender: UIButton) {
    delegate?.userPicker(self, didPressDone: picker)
  }
  
}
