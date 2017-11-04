//
//  UIImageView+RoundThumbnail.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/3/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
  
  func roundThumbnail() {
    layer.cornerRadius = frame.size.width / 2
    clipsToBounds = true
  }
  
}
