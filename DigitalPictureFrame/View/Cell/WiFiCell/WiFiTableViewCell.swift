//
//  WiFiTableViewCell.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/4/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit

class WiFiTableViewCell: UITableViewCell, DigitalPictureFrameCellSetupable, ViewSetupable {
  @IBOutlet weak var thumbnailImageView: UIImageView!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var passwordTextField: UITextField!
  
  
  var rowInSection: Int?
  var item: DigitalPictureFrameItem? {
    didSet {
      guard let wifiItem = item as? WiFiItem, let row = rowInSection else { return }
      let wifiCell = wifiItem.cells[row]
      descriptionLabel.text = wifiCell.description
      passwordTextField.text = wifiCell.value as? String
      thumbnailImageView.image = UIImage(named: wifiCell.thumbnailImageName)
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
    thumbnailImageView.roundThumbnail()
    selectionStyle = .none
    passwordTextField.isSecureTextEntry = true
  }
}
