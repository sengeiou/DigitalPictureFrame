//
//  TableShadowButton.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 12/28/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit

class TableShadowButton: UIButton {
  var indexPath: IndexPath?
  var shadowLayer: CAShapeLayer!
  
  override func layoutSubviews() {
    super.layoutSubviews()
    if shadowLayer == nil {
      shadowLayer = CAShapeLayer()
      shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 12).cgPath
      shadowLayer.fillColor = UIColor.white.cgColor
      
      shadowLayer.shadowColor = UIColor.appleBlue.cgColor
      shadowLayer.shadowPath = shadowLayer.path
      shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
      shadowLayer.shadowOpacity = 0.8
      shadowLayer.shadowRadius = 2
      
      layer.insertSublayer(shadowLayer, at: 0)
    }
  }
}

