//
//  GeneralSettingsTableViewCell.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit

class GeneralSettingsTableViewCell: UITableViewCell, DigitalPictureFrameCellConfigurable, ViewSetupable {
  @IBOutlet weak var thumbnailImageView: UIImageView!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var onOffSwitch: UISwitch!
  
  weak var delegate: SwitchableCellDelegate?
  
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
    //thumbnailImageView.roundThumbnail()
  }
  
}


// MARK: DigitalPictureFrameCellConfigurable protocol
extension GeneralSettingsTableViewCell {
  
  func configureWith(item: DigitalPictureFrameItem, at indexPath: IndexPath) {
    self.rowInSection = indexPath.row
    self.item = item
    self.onOffSwitch.tag = indexPath.section
  }
  
}


// MARK: Actions
extension GeneralSettingsTableViewCell {

  @IBAction func switchPressed(_ sender: UISwitch) {
    guard let rowInSection = rowInSection else { return }
    let index = IndexPath(row: rowInSection, section: sender.tag)
    delegate?.switchableCell(self, didPressSwitch: sender, at: index)
  }
  
}
