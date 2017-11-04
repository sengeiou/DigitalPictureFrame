//
//  DigitalPictureFrameCellDequeueble.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/3/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit

protocol DigitalPictureFrameCellDequeueble: class { }

extension DigitalPictureFrameCellDequeueble where Self: UITableView {
  
  func dequeueDigitalPictureFrameCell<T: UITableViewCell>(cell: T.Type) -> T where T: DigitalPictureFrameCellSetupable {
    let cell = self.dequeueReusableCell(withIdentifier: T.reuseIdentifier) as! T
    return cell
  }
  
}
