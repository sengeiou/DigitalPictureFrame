//
//  WeatherZipcodeSettingsTableViewCell.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/4/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit

class WeatherZipcodeSettingsTableViewCell: UITableViewCell, DigitalPictureFrameCellSetupable {
  @IBOutlet weak var thumbnailImageView: UIImageView!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var valueLabel: UILabel!
  
  var rowInSection: Int?
  var item: DigitalPictureFrameItem? {
    didSet {
      guard let zipCodeItem = item as? SettingsWeatherZipCodeItem, let row = rowInSection else { return }
      let zipCodeCell = zipCodeItem.cells[row]
      descriptionLabel.text = zipCodeCell.description
      valueLabel.text = zipCodeCell.value as? String
      thumbnailImageView.image = UIImage(named: zipCodeCell.thumbnailImageName)
    }
  }
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    selectionStyle = .none
    thumbnailImageView.roundThumbnail()
  }
}


