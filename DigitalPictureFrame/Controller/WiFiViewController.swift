//
//  WiFiViewController.swift
//  Digital Picture Frame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit

class WiFiViewController: BaseViewController {
  private var modifiedItemIndexPath: IndexPath?
  private var connectedSSIDName: String?
  
  
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
    reloadData()
    
    // TODO: Implement
    connectedSSIDName = NetworkConnectionUtility.fetchSSIDInfo()
    print(connectedSSIDName ?? "Not connected")
  }
  
}


// MARK: - Register cells
extension WiFiViewController {
  
  func registerCells() {
    tableView.register(cell: WiFiTableViewCell.self)
  }

  @objc override func reloadData() {
    createAndAssignWiFiDelegate()
    updateTableView()
  }
}





// MARK: - Create assign delegate
extension WiFiViewController {
  
  func createAndAssignWiFiDelegate() {
    guard let wifiInfo = DatabaseManager.shared().wifiInfo else {
      createAndAssignDelegate(for: [])
      return
    }
    let infoItem = WiFiItem(wiFi: wifiInfo)
    createAndAssignDelegate(for: [infoItem])
  }
  
}


// MARK: - WiFiCellDelegate protocol
extension WiFiViewController: WiFiCellDelegate {
  
  func wifiCell(_ cell: WiFiTableViewCell, didPressPasswordButtonAt indexPath: IndexPath) {
    modifiedItemIndexPath = indexPath
    let title = "Wi-Fi Password"
    let message = "Please type in the current Wi-Fi Password"
    sharedAlert.delegate = self
    sharedAlert.presentSubmitAlert(in: self, title: title, message: message, textFieldConfiguration: { textField in
      textField.placeholder = "Current Password"
      textField.keyboardAppearance = .dark
      textField.keyboardType = .default
      textField.clearButtonMode = .whileEditing
      textField.isSecureTextEntry = true
    })
  }
  
}


// MARK: - AlertViewPresenterDelegate protocol
extension WiFiViewController: AlertViewPresenterDelegate {
  
  func alertView(_ alertViewPresenter: AlertViewPresenter, didSubmit result: String) {
    guard let modifiedItemIndexPath = modifiedItemIndexPath else { return }
    guard let modifiedWiFiItem = dataSourceDelegate?.item(at: modifiedItemIndexPath) else { return }
    let newPassword = result
    let wifiItem = modifiedWiFiItem.cells[modifiedItemIndexPath.row]
    wifiItem.value = newPassword
    reloadRows(at: modifiedItemIndexPath)
  }
  
}
