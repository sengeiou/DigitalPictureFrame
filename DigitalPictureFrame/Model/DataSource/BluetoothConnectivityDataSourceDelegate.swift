//
//  BluetoothConnectivityDataSourceDelegate.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 12/7/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit

protocol BluetoothConnectivityDataSourceDelegate: class, UITableViewDataSource, UITableViewDelegate {
  var items: [BluetoothItem]? { get set }
  var delegateVC: UIViewController { get set }
  
  func item(at indexPath: IndexPath) -> BluetoothItem?
}


extension BluetoothConnectivityDataSourceDelegate {
  
  var numberOfRowsInSection: Int {
    return items?.count ?? 0
  }
  
}
