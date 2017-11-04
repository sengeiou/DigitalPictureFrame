//
//  Registrable.swift
//  ARPuzzle15
//
//  Created by Pawel Milek on 10/6/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit

protocol Registrable: class {}


extension Registrable where Self: UITableView {
  
  func register<T: UITableViewCell>(cell: T.Type) {
    let nib = UINib(nibName: T.nibName, bundle: nil)
    register(nib, forCellReuseIdentifier: T.reuseIdentifier)
  }
  
}
