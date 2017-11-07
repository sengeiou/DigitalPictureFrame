//
//  DigitalPictureFrameTableViewDataSourceDelegate.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/3/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit

protocol DigitalPictureFrameDataSourceDelegate: class, UITableViewDataSource, UITableViewDelegate {
  var items: [DigitalPictureFrameItem] { get set }
  var delegateVC: UIViewController { get set }
  
  func itemCount(in section: Int) -> Int
  func item(at indexPath: IndexPath) -> DigitalPictureFrameItem
  func item(at section: Int) -> DigitalPictureFrameItem
}


