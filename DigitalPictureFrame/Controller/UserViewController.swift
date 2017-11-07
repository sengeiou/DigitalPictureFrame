//
//  UserTableViewController.swift
//  Digital Picture Frame
//
//  Created by Pawel Milek on 11/2/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit

class UserViewController: BaseViewController {
  var users: [User]? {
    didSet {
      createAndAssignUserDelegate()
    }
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
}


// MARK: - ViewSetupable protocol
extension UserViewController {
  
  override func setup() {
    super.setup()
    registerCells()
    loadData()
  }
}


// MARK: - Register cells
extension UserViewController {
  
  func registerCells() {
    tableView.register(cell: UserTableViewCell.self)
  }
  
}


// MARK: - Load data
private extension UserViewController {
  
  func loadData() {
    NetworkManager.shared.fetchData(completionHandler: {[unowned self] result in
      switch result {
      case .success(let decodeData):
        DatabaseSingleton.shared.assign(data: decodeData)
        self.users = decodeData.users
        
      case .failure(let error):
        AlertViewPresenter.shared.presentErrorAlert(viewController: self, error: error)
      }
    })
  }
  
  
  func createAndAssignUserDelegate() {
    guard let users = users else { return }
    let userItem = UserItem(users: users)
    createAndAssignDelegate(for: userItem)
  }
  
}
