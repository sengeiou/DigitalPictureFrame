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
      createAndAssembleItem()
    }
  }
  
  
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
extension WiFiViewController {
  
  override func setup() {
    super.setup()
    registerCells()
  }

  func setupStyle() {
    tableView.separatorStyle = .none
  }

  
  func createAndAssembleItem() {
    guard let wifiInfo = wifiInfo else { return }
    let infoItem = WiFiItem(wiFi: wifiInfo)
    dataSourceDelegate = DigitalPictureFrameDataSource(items: [infoItem])
    
    tableView.dataSource = dataSourceDelegate
    tableView.delegate = dataSourceDelegate
  }
}


// MARK: - Register cells
extension WiFiViewController {
  
  func registerCells() {
    tableView.register(cell: WiFiTableViewCell.self)
  }
  
}
