//
//  BaseViewController.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/2/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, ViewSetupable {
  @IBOutlet weak var tableView: UITableView!
  
  let sharedAlert = AlertViewPresenter.shared
  var dataSourceDelegate: DigitalPictureFrameDataSourceDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
//  func registerCells() {
//    // override in subclass
//  }
}


// MARK: - ViewSetupable protocol
extension BaseViewController {
  
  func setup() {
//    registerCells()
  }
  
}
