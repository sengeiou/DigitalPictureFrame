//
//  ViewControllerTransitionable.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 12/21/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit

protocol ViewControllerTransitionable: class { }


extension ViewControllerTransitionable where Self: UIViewController {
  
  func transitionPresent(_ viewController: UIViewController) {
    let transition = CATransition()
    transition.duration = 0.25
    transition.type = kCATransitionPush
    transition.subtype = kCATransitionFromRight
    self.view.window!.layer.add(transition, forKey: kCATransition)
    
    present(viewController, animated: false)
  }
  
  func transitionDismiss() {
    let transition = CATransition()
    transition.duration = 0.25
    transition.type = kCATransitionPush
    transition.subtype = kCATransitionFromLeft
    self.view.window!.layer.add(transition, forKey: kCATransition)
    
    dismiss(animated: false)
  }
}

