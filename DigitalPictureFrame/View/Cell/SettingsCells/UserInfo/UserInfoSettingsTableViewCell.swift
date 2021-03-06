//
//  UserInfoSettingsTableViewCell.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit

class UserInfoSettingsTableViewCell: UITableViewCell, DigitalPictureFrameCellConfigurable, ViewSetupable {
  @IBOutlet weak var thumbnailImageView: UIImageView!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var valueLabel: UILabel!
  @IBOutlet weak var userButton: TableShadowButton!
  
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
  
  @IBAction func userPickerButtonPressed(_ sender: TableShadowButton) {
    guard let indexPath = sender.indexPath else { return }
    delegate?.userInfoSettingsCell(self, didPressUserPickerButtonAt: indexPath)
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
    userButton.setTitle("", for: .normal)
    valueLabel.textAlignment = .center
    thumbnailImageView.contentMode = .scaleAspectFit
  }
  
}


// MARK: DigitalPictureFrameCellConfigurable protocol
extension UserInfoSettingsTableViewCell {
  
  func configure(with item: DigitalPictureFrameItem, at indexPath: IndexPath) {
    self.rowInSection = indexPath.row
    self.item = item
    self.userButton.indexPath = indexPath
  }
  
}
