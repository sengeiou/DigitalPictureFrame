//
//  TableSectionButton.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit

class TableSectionButton: UIButton {
  var indexPath: IndexPath
  
  
  override init(frame: CGRect) {
    self.indexPath = IndexPath()
    
    super.init(frame: frame)
  }

  required init?(coder aDecoder: NSCoder) {
    self.indexPath = IndexPath()
    
    super.init(coder: aDecoder)
  }
  
}
