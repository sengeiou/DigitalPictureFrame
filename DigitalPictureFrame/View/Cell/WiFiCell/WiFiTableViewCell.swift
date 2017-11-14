//
//  WiFiTableViewCell.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit

class WiFiTableViewCell: UITableViewCell, DigitalPictureFrameCellConfigurable, ViewSetupable {
  @IBOutlet weak var thumbnailImageView: UIImageView!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var passwordButton: TableSectionButton!
  
  weak var delegate: WiFiCellDelegate?
  
  var rowInSection: Int?
  var item: DigitalPictureFrameItem? {
    didSet {
      guard let wifiItem = item as? WiFiItem, let row = rowInSection else { return }
      let wifiCell = wifiItem.cells[row]
      
      func checkConnectedWirelessNetwork() {
        guard let connectedNetworkSSID = NetworkConnectionUtility.fetchSSIDInfo() else {
          sendNotificationToShowMessageViewThatNoWirelessNetworkConnected()
          return
        }
        
        if connectedNetworkSSID.contains(wifiCell.description) {
          let wifiComponents = WiFiInfo.extractComponents(from: wifiCell.value as! String)
          descriptionLabel.text = wifiComponents.name
          passwordTextField.text = wifiComponents.password
          
        } else {
          descriptionLabel.text = connectedNetworkSSID
          passwordTextField.text = ""
          sendNotificationToShowMessageViewEnterNewWirelessNetworkPassword()
        }
      }
      
      
      thumbnailImageView.image = UIImage(named: wifiCell.thumbnailImageName)
      checkConnectedWirelessNetwork()
    }
  }
  

  override func awakeFromNib() {
    super.awakeFromNib()
    setup()
  }
}


// MARK: ViewSetupable protocol
extension WiFiTableViewCell {
  
  func setup() {
    selectionStyle = .none
    passwordTextField.isUserInteractionEnabled = false
    passwordTextField.isSecureTextEntry = true
    passwordTextField.textAlignment = .right
    thumbnailImageView.contentMode = .scaleAspectFit
    thumbnailImageView.roundThumbnail()
  }
}


// MARK: DigitalPictureFrameCellConfigurable protocol
extension WiFiTableViewCell {
  
  func configure(by item: DigitalPictureFrameItem, at indexPath: IndexPath) {
    self.passwordButton.indexPath = indexPath
    self.rowInSection = indexPath.row
    self.item = item
  }
  
}


// MARK: - Send notification to enter new network password
private extension WiFiTableViewCell {
  
  func sendNotificationToShowMessageViewEnterNewWirelessNetworkPassword() {
    NotificationCenter.default.post(name: NotificationName.showAlertViewMessageToEnterNewWirelessNetworkPassword.name, object: nil)
  }
  
  func sendNotificationToShowMessageViewThatNoWirelessNetworkConnected() {
    NotificationCenter.default.post(name: NotificationName.showAlertViewMessageNoWirelessNetworkConnected.name, object: nil)
  }
  
}


// MARK: Actions
extension WiFiTableViewCell {
  
  @IBAction func enterPasswordButtonPressed(_ sender: TableSectionButton) {
    delegate?.wifiCell(self, didPressPasswordButtonAt: sender.indexPath)
  }
  
}
