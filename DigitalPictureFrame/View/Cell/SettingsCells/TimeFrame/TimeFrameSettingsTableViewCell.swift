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
  
  var rowInSection: Int?
  var item: DigitalPictureFrameItem? {
    didSet {
      guard let timeFrameItem = item as? SettingsTimeItem, let row = rowInSection else { return }
      let timeFrameCell = timeFrameItem.cells[row]
      descriptionLabel.text = timeFrameCell.description
      valueLabel.text = timeFrameCell.value as? String
      thumbnailImageView.image = UIImage(named: timeFrameCell.thumbnailImageName)
    }
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
    thumbnailImageView.contentMode = .scaleAspectFit
    thumbnailImageView.roundThumbnail()
  }
  
}
