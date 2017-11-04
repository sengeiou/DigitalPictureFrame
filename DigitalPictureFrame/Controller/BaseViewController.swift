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
  
}


// MARK: - ViewSetupable protocol
extension BaseViewController {
  
  func setup() {
    registerCells()
  }
  
}


// MARK: - Register cells
private extension BaseViewController {
  
  func registerCells() {
    tableView.register(cell: ImageDescriptionSwitchTableViewCell.self)
    tableView.register(cell: ImageDescriptionRightTextTableViewCell.self)
  }
  
}
