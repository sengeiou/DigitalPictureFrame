//
//  SettingsViewController.swift
//  Digital Picture Frame
//
//  Created by Pawel Milek on 11/2/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController {
  var settings: Settings?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
}


// MARK: - ViewSetupable protocol
extension SettingsViewController {
  
  override func setup() {
    super.setup()
    tableView.dataSource = dataSourceDelegate
    tableView.delegate = dataSourceDelegate
  }
  
}
