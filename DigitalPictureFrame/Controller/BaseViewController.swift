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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupStyle()
  }
}


// MARK: - ViewSetupable protocol
extension BaseViewController {
  
  func setup() {
    // TODO: Override in subclass
  }
  
  func setupStyle() {
    tableView.separatorStyle = .none
  }
  
}


// MARK: - Create assign delegate
extension BaseViewController {
  
  func createAndAssignDelegate(for items: DigitalPictureFrameItem) {
    let infoItem = [items]
    
    if let dataSourceDelegate = dataSourceDelegate {
      dataSourceDelegate.items = infoItem
      tableView.reloadData()
    } else {
      dataSourceDelegate = DigitalPictureFrameDataSource(self, items: infoItem)
      tableView.dataSource = dataSourceDelegate
      tableView.delegate = dataSourceDelegate
    }
  }
  
}

