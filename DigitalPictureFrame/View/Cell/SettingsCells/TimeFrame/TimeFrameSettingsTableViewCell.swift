//
//  TimeFrameSettingsTableViewCell.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit

class TimeFrameSettingsTableViewCell: UITableViewCell, DigitalPictureFrameCellConfigurable, ViewSetupable {
  @IBOutlet weak var thumbnailImageView: UIImageView!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var valueLabel: UILabel!
  @IBOutlet weak var timePickerButton: TableShadowButton!
  
  weak var delegate: TimeFrameSettingsCellDelegate?
  
  var rowInSection: Int?
  var item: DigitalPictureFrameItem? {
    didSet {
      guard let timeFrameItem = item as? SettingsTimeItem, let row = rowInSection else { return }
      let timeFrameCell = timeFrameItem.cells[row]
      descriptionLabel.text = timeFrameCell.description
      let timestamp = timeFrameCell.value as? String
      let time = Date.shortTime(from: timestamp ?? "")
      
      valueLabel.text = time
      thumbnailImageView.image = UIImage(named: timeFrameCell.thumbnailImageName)
    }
  }
  
  @IBAction func timePickerButtonPressed(_ sender: TableShadowButton) {
    guard let indexPath = sender.indexPath else { return }
    delegate?.timeFrameSettingsCell(self, didPressTimePickerButtonAt: indexPath)
  }
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setup()
  }
}

// MARK: ViewSetupable protocol
extension TimeFrameSettingsTableViewCell {
  
  func setup() {
    selectionStyle = .none
    valueLabel.textAlignment = .center
    timePickerButton.setTitle("", for: .normal)
    thumbnailImageView.contentMode = .scaleAspectFit
  }
  
}

// MARK: DigitalPictureFrameCellConfigurable protocol
extension TimeFrameSettingsTableViewCell {
  
  func configure(with item: DigitalPictureFrameItem, at indexPath: IndexPath) {
    self.rowInSection = indexPath.row
    self.item = item
    self.timePickerButton.indexPath = indexPath
  }
  
}
