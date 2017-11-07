//
//  WiFiViewController.swift
//  Digital Picture Frame
//
//  Created by Pawel Milek on 11/2/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit

class WiFiViewController: BaseViewController {
  var wifiInfo: WiFiInfo? {
    didSet {
      createAndAssignWiFiDelegate()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
}


// MARK: - ViewSetupable protocol
extension WiFiViewController {
  
  override func setup() {
    super.setup()
    registerCells()
  }
  
}


// MARK: - Register cells
extension WiFiViewController {
  
  func registerCells() {
    tableView.register(cell: WiFiTableViewCell.self)
  }
  
}


// MARK: - Create assign delegate
extension WiFiViewController {
  
  func createAndAssignWiFiDelegate() {
    guard let wifiInfo = wifiInfo else { return }
    let infoItem = WiFiItem(wiFi: wifiInfo)
    
    createAndAssignDelegate(for: infoItem)
  }
  
}
