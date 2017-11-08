//
//  TimePicker.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/6/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit

class TimePicker: ListPickerView {
  
  convenience init(presenterViewController: UIViewController, frame: CGRect) {
//    self.init(frame: frame)
    super.init(presenterViewController: presenterViewController, frame: frame)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}
