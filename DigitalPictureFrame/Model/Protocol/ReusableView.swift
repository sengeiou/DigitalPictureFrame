//
//  ReusableView.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit

protocol ReusableView: class {}

extension ReusableView where Self: UIView {
  
  static var reuseIdentifier: String {
    return "\(self)"
  }
  
}
