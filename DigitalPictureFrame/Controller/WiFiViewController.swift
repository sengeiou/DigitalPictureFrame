//
//  WiFiViewController.swift
//  Digital Picture Frame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit

class WiFiViewController: PageContentViewController {
  private var modifiedItemIndexPath: IndexPath?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    verifyConnectedNetwork()
  }
}


// MARK: - ViewSetupable protocol
extension WiFiViewController {
  
  override func setup() {
    super.setup()
    registerCells()
    reloadData()
  }
  
}


// MARK: - Register cells
extension WiFiViewController {
  
  func registerCells() {
    tableView.register(cell: WiFiTableViewCell.self)
  }
  
}


// MARK: - Reload Data
extension WiFiViewController {
  
  @objc override func reloadData() {
    createAndAssignWiFiDelegate()
    updateTableView()
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


// MARK: - Verify Connected Network
private extension WiFiViewController {
  
  func verifyConnectedNetwork() {
    guard let wifiInfo = DatabaseManager.shared().wifiInfo else { return }
    guard let connectedNetworkSSID = NetworkConnectionUtility.fetchSSIDInfo() else {
      showMessageNoWirelessNetworkConnected()
      return
    }
    
    if !connectedNetworkSSID.isEqual(to: wifiInfo.name) {
      showMessageToEnterNewWirelessNetworkPassword()
    }
  }
  
  func showMessageToEnterNewWirelessNetworkPassword() {
    let title = NSLocalizedString("WIFI_NEW_WIRELESS_NETWORK_PASSWORD_ALERT_TITLE", comment: "")
    let message = NSLocalizedString("WIFI_NEW_WIRELESS_NETWORK_PASSWORD_ALERT_MSG", comment: "")
    sharedAlert.presentPopupAlert(in: self, title: title, message: message)
  }
  
  func showMessageNoWirelessNetworkConnected() {
    let title = NSLocalizedString("WIFI_NO_WIRELESS_NETWORK_CONNECTED_ALERT_TITLE", comment: "")
    let message = NSLocalizedString("WIFI_NO_WIRELESS_NETWORK_CONNECTED_ALERT_MSG", comment: "")
    sharedAlert.presentPopupAlert(in: self, title: title, message: message)
  }
  
}


// MARK: - WiFiCellDelegate protocol
extension WiFiViewController: WiFiCellDelegate {
  
  func wifiCell(_ cell: WiFiTableViewCell, didPressPasswordButtonAt indexPath: IndexPath) {
    modifiedItemIndexPath = indexPath
    let title = NSLocalizedString("WIFI_ENTER_WIRELESS_NETWORK_PASSWORD_ALERT_TITLE", comment: "")
    let message = NSLocalizedString("WIFI_ENTER_WIRELESS_NETWORK_PASSWORD_ALERT_MSG", comment: "")
    sharedAlert.delegate = self
    sharedAlert.presentSubmitAlert(in: self, title: title, message: message, textFieldConfiguration: { textField in
      textField.placeholder = NSLocalizedString("WIFI_ENTER_WIRELESS_NETWORK_PASSWORD_ALERT_PLACEHOLDER", comment: "")
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
    
    let newPassword = result
    let encryptedBytes = Cryptor.shared.encrypt(password: newPassword)
    let passwordEncodedBase64 = Cryptor.shared.convertIntoBase64Encrypted(data: encryptedBytes)
    
    let fetchedWiFiName = modifiedWiFiItem.wiFi.name
    let connectedWiFiName = NetworkConnectionUtility.fetchSSIDInfo() ?? NSLocalizedString("WIFI_WIRELESS_NETWORK_CONNECTED_LABEL_NOT_AVAILABLE", comment: "")
    let wifiComponents = fetchedWiFiName.contains(connectedWiFiName) ? "\(fetchedWiFiName):\(passwordEncodedBase64)" : "\(connectedWiFiName):\(passwordEncodedBase64)"
    
    let wifiCell = modifiedWiFiItem.cells[modifiedItemIndexPath.row]
    wifiCell.value = wifiComponents
    reloadRows(at: modifiedItemIndexPath)
  }
  
}
