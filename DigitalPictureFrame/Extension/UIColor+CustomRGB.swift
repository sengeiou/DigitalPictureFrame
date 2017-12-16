//
//  UIColor+CustomRGB.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit


extension UIColor {
  
  static var appleBlue: UIColor {
    return UIColor.colorRGB(component: (red: CGFloat(12), green: CGFloat(100), blue: CGFloat(255)))
  }

  static var groupGray: UIColor {
    return UIColor.colorRGB(component: (red: CGFloat(235), green: CGFloat(235), blue: CGFloat(241)))
  }
  
  static private func colorRGB(component: (red: CGFloat, green: CGFloat, blue: CGFloat), alpha: CGFloat = 1.0) -> UIColor {
    return UIColor(red: component.red/255, green: component.green/255, blue: component.blue/255, alpha: alpha)
  }
}
