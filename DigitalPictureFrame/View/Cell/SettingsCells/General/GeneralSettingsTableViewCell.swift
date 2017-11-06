//
//  GeneralSettingsTableViewCell.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/4/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit

class GeneralSettingsTableViewCell: UITableViewCell, DigitalPictureFrameCellSetupable, ViewSetupable {
  @IBOutlet weak var thumbnailImageView: UIImageView!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var onOffSwitch: UISwitch!
  
  var rowInSection: Int?
  var item: DigitalPictureFrameItem? {
    didSet {
      guard let generalItem = item as? SettingsGeneralItem, let row = rowInSection else { return }
      let settingCell = generalItem.cells[row]
      descriptionLabel.text = settingCell.description
      onOffSwitch.isOn = settingCell.value as! Bool
      thumbnailImageView.image = UIImage(named: settingCell.thumbnailImageName)
    }
  }
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setup()
  }
}


// MARK: ViewSetupable protocol
extension GeneralSettingsTableViewCell {
  
  func setup() {
    selectionStyle = .none
    thumbnailImageView.contentMode = .scaleAspectFit
    thumbnailImageView.roundThumbnail()
  }
  
}
