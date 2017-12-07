//
//  BluetoothConnectivityViewController+Actions.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit
import ConcentricProgressRingView

extension BluetoothConnectivityViewController {
  
  @IBAction func sendJSONButtonPressed(_ sender: UIButton) {
    // TODO: Implement
    
    let fgColor1 = UIColor.yellow
    let bgColor1 = UIColor.darkGray
    let fgColor2 = UIColor.green
    let bgColor2 = UIColor.darkGray
    
    let rings = [
      ProgressRing(color: fgColor1, backgroundColor: bgColor1, width: 18),
      ProgressRing(color: fgColor2, backgroundColor: bgColor2, width: 18),
      ]
    
    let margin: CGFloat = 2
    let radius: CGFloat = 80
    let progressRingView = ConcentricProgressRingView(center: sendJSONFileButton.center, radius: radius, margin: margin, rings: rings)
    sendJSONFileButton.addSubview(progressRingView)
  }
  
  
  @IBAction func searchDevicesButtonPressed(_ sender: UIButton) {
    // TODO: Implement
  }
  
}
