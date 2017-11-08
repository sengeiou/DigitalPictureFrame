//
//  UserTableViewController.swift
//  Digital Picture Frame
//
//  Created by Pawel Milek on 11/2/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit

class UserViewController: BaseViewController, SwitchableCellDelegate {
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  deinit {
    unregisterNotifications()
  }
}


// MARK: - ViewSetupable protocol
extension UserViewController {
  
  override func setup() {
    super.setup()
    registerNotifications()
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
  
  func registerNotifications() {
    addNofificationObserverToReloadUserVC()
  }
  
  func unregisterNotifications() {
    removeNofificationObserverReloadingUserVC()
  }
  
  
  func addNofificationObserverToReloadUserVC() {
    NotificationCenter.default.addObserver(self, selector: #selector(UserViewController.reloadDataInUserViewController),
                                           name: NotificationName.reloadDataInUserViewController.name, object: nil)
  }
  
  func removeNofificationObserverReloadingUserVC() {
    NotificationCenter.default.removeObserver(self, name: NotificationName.reloadDataInUserViewController.name, object: nil)
  }
  
  
  @objc func reloadDataInUserViewController() {
    createAndAssignUserDelegate()
  }
}


// MARK: - Create and assign delegate
private extension UserViewController {
  
  func createAndAssignUserDelegate() {
    let users = DatabaseManager.shared().users
    let userItem = UserItem(users: users)
    createAndAssignDelegate(for: userItem)
  }
  
}

