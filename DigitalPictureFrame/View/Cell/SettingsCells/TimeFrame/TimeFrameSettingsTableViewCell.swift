//
//  TimeFrameSettingsTableViewCell.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/4/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit

class TimeFrameSettingsTableViewCell: UITableViewCell, DigitalPictureFrameCellSetupable, ViewSetupable {
  @IBOutlet weak var thumbnailImageView: UIImageView!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var valueLabel: UILabel!
  @IBOutlet weak var timePickerButton: TableSectionButton!
  
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
  
  @IBAction func timePickerButtonPressed(_ sender: TableSectionButton) {
    delegate?.timeFrameSettingsCell(self, didPressTimePickerButtonAt: sender.indexPath)
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
    timePickerButton.setTitle("", for: .normal)
    thumbnailImageView.contentMode = .center
    thumbnailImageView.roundThumbnail()
  }
  
}

// MARK: DigitalPictureFrameCellSetupable protocol
extension TimeFrameSettingsTableViewCell {
  
  func setup(by item: DigitalPictureFrameItem, at indexPath: IndexPath) {
    self.rowInSection = indexPath.row
    self.item = item
    self.timePickerButton.indexPath = indexPath
  }
  
}
