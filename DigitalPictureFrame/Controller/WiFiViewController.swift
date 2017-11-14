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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  deinit {
    unregisterWiFiNotifications()
  }
}


// MARK: - ViewSetupable protocol
extension WiFiViewController {
  
  override func setup() {
    super.setup()
    registerCells()
    reloadData()
    registerWiFiNotifications()
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
    guard let wifiInfo = DatabaseManager.shared().wifiInfo else {
      clearDataSource()
      return
    }
    let infoItem = WiFiItem(wiFi: wifiInfo)
    createAndAssignDelegate(for: [infoItem])
  }
}


// MARK: - Reload Data
extension WiFiViewController {
  
  @objc override func reloadData() {
    createAndAssignWiFiDelegate()
    updateTableView()
  }
 
}


// MARK: - Add Notification Observer
extension WiFiViewController {
  
  func registerWiFiNotifications() {
    addShowMessageToEnterNewWirelessNetworkPasswordNofificationObserver()
    addShowMessageNoWirelessNetworkConnectedNofificationObserver()
  }
  
  func unregisterWiFiNotifications() {
    removeShowMessageToEnterNewWirelessNetworkPasswordNofificationObserver()
    removeShowMessageNoWirelessNetworkConnectedNofificationObserver()
  }
  
  
  func addShowMessageToEnterNewWirelessNetworkPasswordNofificationObserver() {
    NotificationCenter.default.addObserver(self, selector: #selector(WiFiViewController.showMessageToEnterNewWirelessNetworkPassword(_:)),
                                           name: NotificationName.showAlertViewMessageToEnterNewWirelessNetworkPassword.name, object: nil)
  }
  
  func removeShowMessageToEnterNewWirelessNetworkPasswordNofificationObserver() {
    NotificationCenter.default.removeObserver(self, name: NotificationName.showAlertViewMessageToEnterNewWirelessNetworkPassword.name, object: nil)
  }
  
  func addShowMessageNoWirelessNetworkConnectedNofificationObserver() {
    NotificationCenter.default.addObserver(self, selector: #selector(WiFiViewController.showMessageNoWirelessNetworkConnected(_:)),
                                           name: NotificationName.showAlertViewMessageNoWirelessNetworkConnected.name, object: nil)
  }
  
  func removeShowMessageNoWirelessNetworkConnectedNofificationObserver() {
    NotificationCenter.default.removeObserver(self, name: NotificationName.showAlertViewMessageNoWirelessNetworkConnected.name, object: nil)
  }
  
  @objc func showMessageToEnterNewWirelessNetworkPassword(_ sender: Any) {
    let title = "Alert"
    let message = "Wireless network is different than what is currently associated with user.\nEnter password for new Wi-Fi name."
    sharedAlert.presentPopupAlert(in: self, title: title, message: message)
  }
  
  @objc func showMessageNoWirelessNetworkConnected(_ sender: Any) {
    let title = "Alert"
    let message = "No wireless network connected"
    sharedAlert.presentPopupAlert(in: self, title: title, message: message)
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
    guard let modifiedWiFiItem = dataSourceDelegate?.item(at: modifiedItemIndexPath) as? WiFiItem else { return }
    
    let crypt = Crypt()
    let newPassword = result
    let encryptedBytes = crypt.encryptContentsToSecureData(for: newPassword)
    let passwordEncodedBase64 = crypt.convertIntoBase64Encoded(data: encryptedBytes)
    
    let fetchedWiFiName = modifiedWiFiItem.wiFi.name
    let connectedWiFiName = NetworkConnectionUtility.fetchSSIDInfo() ?? "Not available"
    let wifiComponents = fetchedWiFiName.contains(connectedWiFiName) ? "\(fetchedWiFiName):\(passwordEncodedBase64)" : "\(connectedWiFiName):\(passwordEncodedBase64)"
    
    let wifiCell = modifiedWiFiItem.cells[modifiedItemIndexPath.row]
    wifiCell.value = wifiComponents
    reloadRows(at: modifiedItemIndexPath)
  }
  
}
