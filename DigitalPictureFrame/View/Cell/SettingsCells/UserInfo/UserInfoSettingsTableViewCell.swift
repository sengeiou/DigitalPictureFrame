//
//  UserInfoSettingsTableViewCell.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/4/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit

class UserInfoSettingsTableViewCell: UITableViewCell, DigitalPictureFrameCellSetupable, ViewSetupable {
  @IBOutlet weak var thumbnailImageView: UIImageView!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var valueLabel: UILabel!
  
  weak var delegate: UserInfoSettingsCellDelegate?
  var rowInSection: Int?
  var item: DigitalPictureFrameItem? {
    didSet {
      guard let userInfoItem = item as? SettingsUserInfoItem, let row = rowInSection else { return }
      let userInfoCell = userInfoItem.cells[row]
      descriptionLabel.text = userInfoCell.description
      valueLabel.text = userInfoCell.value as? String
      thumbnailImageView.image = UIImage(named: userInfoCell.thumbnailImageName)
    }
  }
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setup()
  }
}


// MARK: ViewSetupable protocol
extension UserInfoSettingsTableViewCell {
  
  func setup() {
    selectionStyle = .none
    thumbnailImageView.contentMode = .scaleAspectFit
    thumbnailImageView.roundThumbnail()
  }
  
}
