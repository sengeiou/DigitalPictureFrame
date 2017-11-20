//
//  UIImageView+TintImageColor.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/19/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit

extension UIImageView {
  
  func tintImage(color: UIColor) {
    self.image = self.image?.withRenderingMode(.alwaysTemplate)
    self.tintColor = color
  }
  
}
