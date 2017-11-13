//
//  UserTableViewController.swift
//  Digital Picture Frame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit

class UserViewController: BaseViewController, SwitchableCellDelegate {
  
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
  }
}


// MARK: - Register cells
extension UserViewController {
  
  func registerCells() {
    tableView.register(cell: UserTableViewCell.self)
  }
  
}


// MARK: - Add Notification Observer
extension UserViewController {
  
  @objc override func reloadData() {
    createAndAssignUserDelegate()
    updateTableView()
  }
}


// MARK: - Create and assign delegate
private extension UserViewController {
  
  func createAndAssignUserDelegate() {
    guard let users = DatabaseManager.shared().users else {
      createAndAssignDelegate(for: [])
      return
    }
    
    let userItem = UserItem(users: users)
    createAndAssignDelegate(for: [userItem])
  }
  
}

