//
//  ReusableView.swift
//  ARPuzzle15
//
//  Created by Pawel Milek on 10/6/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit

protocol ReusableView: class {}

extension ReusableView where Self: UIView {
  
  static var reuseIdentifier: String {
    return "\(self)"
  }
  
}
