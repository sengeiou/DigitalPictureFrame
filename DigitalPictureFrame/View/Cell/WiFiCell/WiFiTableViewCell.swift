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
      
      func checkConnectedWirelessNetwork(passwordHandler: ((_ base64EncryptedPassword: String)->())) {
        guard let connectedNetworkSSID = NetworkConnectionUtility.fetchSSIDInfo() else {
          passwordTextField.isEnabled = false
          return
        }
        
        if connectedNetworkSSID.isEqual(to: wifiCell.description) {
          let wifiComponents = WiFiInfo.extractComponents(from: wifiCell.value as! String)
          descriptionLabel.text = wifiComponents.name
          passwordHandler(wifiComponents.password)
          
          let templateImage = thumbnailImageView.image?.withRenderingMode(.alwaysTemplate)
          thumbnailImageView.image = templateImage
          thumbnailImageView.tintColor = UIColor.green
        } else {
          descriptionLabel.text = connectedNetworkSSID
          passwordTextField.text = ""
        }
      }
      
      
      descriptionLabel.text = ""
      passwordTextField.text = ""
      thumbnailImageView.image = UIImage(named: wifiCell.thumbnailImageName)
      checkConnectedWirelessNetwork() {
        let crypt = Crypt()
        guard let data = crypt.convertIntoData(string: $0),
              let pwd = crypt.decryptContents(of: data) else { return }
        passwordTextField.text = pwd
      }
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
    passwordTextField.isEnabled = true
    passwordTextField.isUserInteractionEnabled = false
    passwordTextField.isSecureTextEntry = true
    passwordTextField.textAlignment = .right
    thumbnailImageView.contentMode = .scaleAspectFit
  }
}


// MARK: DigitalPictureFrameCellConfigurable protocol
extension WiFiTableViewCell {
  
  func configure(with item: DigitalPictureFrameItem, at indexPath: IndexPath) {
    self.passwordButton.indexPath = indexPath
    self.rowInSection = indexPath.row
    self.item = item
  }
  
}


// MARK: Actions
extension WiFiTableViewCell {
  
  @IBAction func enterPasswordButtonPressed(_ sender: TableSectionButton) {
    guard let indexPath = sender.indexPath, passwordTextField.isEnabled else { return }
    delegate?.wifiCell(self, didPressPasswordButtonAt: indexPath)
  }
  
}
