//
//  UIApplication+TopViewController.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
  
  static var topViewController: UIViewController? {
    guard var topVC = shared.keyWindow?.rootViewController else { return nil }
    
    while let next = topVC.presentedViewController {
      topVC = next
    }
    
    return topVC
  }
}
