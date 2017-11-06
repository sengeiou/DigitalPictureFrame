//
//  UserTableViewCell.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/4/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell, DigitalPictureFrameCellSetupable, ViewSetupable {
  @IBOutlet weak var thumbnailImageView: UIImageView!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var onOffSwitch: UISwitch!
  
  
  var rowInSection: Int?
  var item: DigitalPictureFrameItem? {
    didSet {
      guard let userItem = item as? UserItem, let row = rowInSection else { return }
      let user = userItem.users[row]
      descriptionLabel.text = user.name
      onOffSwitch.isOn = user.enabled
      
      if let imageData = Data(base64Encoded: user.image) {
        let userImage = UIImage(data: imageData)
        thumbnailImageView.image = userImage
      }
    }
  }
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setup()
  }
}

// MARK: ViewSetupable protocol
extension UserTableViewCell {
  
  func setup() {
    selectionStyle = .none
    thumbnailImageView.contentMode = .scaleAspectFit
    thumbnailImageView.roundThumbnail()
  }
  
}
