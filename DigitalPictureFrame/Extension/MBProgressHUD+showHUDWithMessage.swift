//
//  MBProgressHUD+showHUDWithMessage.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import MBProgressHUD

extension MBProgressHUD {
  
  static func showHUD(in view: UIView, with message: String) {
    let hud = MBProgressHUD.showAdded(to: view, animated: true)
    hud.mode = MBProgressHUDMode.text
    hud.label.text = message
    hud.hide(animated: true, afterDelay: 1.0)
  }
  
}
