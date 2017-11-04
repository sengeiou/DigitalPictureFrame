//
//  UserTableViewController.swift
//  Digital Picture Frame
//
//  Created by Pawel Milek on 11/2/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit

class UserViewController: BaseViewController {
  var users: [User]?
  
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
extension UserViewController {
  
  override func setup() {
    super.setup()
    loadData()
  }
  
  func setupStyle() {
    tableView.separatorStyle = .none
  }
}


// MARK: - Load data
private extension UserViewController {
  
  func loadData() {
    NetworkManager.shared.fetchData(completionHandler: {[unowned self] result in
      switch result {
      case .success(let decodeData):
        self.users = decodeData.users
        self.assignDelegateAndReload()
        
      case .failure(let error):
        AlertViewPresenter.shared.presentErrorAlert(viewController: self, error: error)
      }
    })
  }
  
  
  func assignDelegateAndReload() {
    guard let users = users else { return }
    
    let userItem = UserItem(users: users)
//    dataSourceDelegate = DigitalPictureFrameDataSource(items: [userItem])
//    tableView.dataSource = dataSourceDelegate
//    tableView.delegate = dataSourceDelegate
//    tableView.reloadData()
  }
  
}
