//
//  NibLoadableView.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit

protocol NibLoadableView: class { }


// MARK: - Nib Name
extension NibLoadableView where Self: UIView {
  
  static var nibName: String {
    return String(describing: self)
  }
  
}


// MARK: - Load View From Nib
extension NibLoadableView where Self: UIView {
  
  static func loadFromNib() -> Self {
    let nib = UINib(nibName: Self.nibName, bundle: nil)
    let loadedView = nib.instantiate(withOwner: Self.self, options: nil)[0] as! Self
    return loadedView
  }
  
}
