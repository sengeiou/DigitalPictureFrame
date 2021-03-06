//
//  DigitalPictureFrameDataModelSDelegate.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit

protocol DigitalPictureFrameDataModelDelegate: class, UITableViewDataSource, UITableViewDelegate {
  var items: [DigitalPictureFrameItem]? { get set }
  var delegateVC: UIViewController { get set }
  
  func itemCount(in section: Int) -> Int
  func item(at indexPath: IndexPath) -> DigitalPictureFrameItem?
  func item(at section: Int) -> DigitalPictureFrameItem?
}


extension DigitalPictureFrameDataModelDelegate {
  
  var numberOfSections: Int {
    return items?.count ?? 0
  }
}



