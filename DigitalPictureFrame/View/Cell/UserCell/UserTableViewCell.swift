//
//  UserTableViewCell.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell, DigitalPictureFrameCellConfigurable, ViewSetupable {
  @IBOutlet weak var thumbnailImageView: UIImageView!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var onOffSwitch: UISwitch!
  
  weak var delegate: SwitchableCellDelegate?
  
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


// MARK: DigitalPictureFrameCellConfigurable protocol
extension UserTableViewCell {
  
  func configure(by item: DigitalPictureFrameItem, at indexPath: IndexPath) {
    self.rowInSection = indexPath.row
    self.item = item
    self.onOffSwitch.tag = indexPath.section
  }
  
}


// MARK: Actions
extension UserTableViewCell {
  
  @IBAction func switchPressed(_ sender: UISwitch) {
    guard let rowInSection = rowInSection else { return }
    let index = IndexPath(row: rowInSection, section: sender.tag)
    delegate?.switchableCell(self, didPressSwitch: sender, at: index)
  }
  
}
