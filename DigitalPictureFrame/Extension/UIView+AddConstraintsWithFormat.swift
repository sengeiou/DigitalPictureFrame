//
//  UIView+AddConstraintsWithFormat.swift
//  iOS-CNH-MobileDealerConnect
//
//  Created by Pawel Milek on 3/12/17.
//  Copyright © 2017 Reply Inc. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
  
  func addConstraintsWith(format: String, forView: UIView ...) {
    var viewsDictionary = [String: UIView]()
    
    for (index, view) in forView.enumerated() {
      let key = "view\(index)"
      view.translatesAutoresizingMaskIntoConstraints = false
      viewsDictionary[key] = view
    }
    
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format,
                                                  options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
  }
  
}
