//
//  WeatherZipcodeSettingsTableViewCell.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit

class WeatherZipcodeSettingsTableViewCell: UITableViewCell, DigitalPictureFrameCellConfigurable, ViewSetupable {
  @IBOutlet weak var thumbnailImageView: UIImageView!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var valueLabel: UILabel!
  @IBOutlet weak var zipcodeButton: TableSectionButton!
  
  weak var delegate: WeatherZipcodeSettingsCellDelegate?
  
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
    setup()
  }
}


// MARK: ViewSetupable protocol
extension WeatherZipcodeSettingsTableViewCell {
  
  func setup() {
    selectionStyle = .none
    thumbnailImageView.contentMode = .scaleAspectFit
    thumbnailImageView.roundThumbnail()
  }
  
}


// MARK: DigitalPictureFrameCellConfigurable protocol
extension WeatherZipcodeSettingsTableViewCell {
  
  func configure(by item: DigitalPictureFrameItem, at indexPath: IndexPath) {
    self.rowInSection = indexPath.row
    self.item = item
    self.zipcodeButton.indexPath = indexPath
  }
  
}

// MARK: - Actions
extension WeatherZipcodeSettingsTableViewCell {
  
  @IBAction func zipcodeButtonPressed(_ sender: TableSectionButton) {
    delegate?.weatherZipcodeSettingsCell(self, didPressZipcodeButtonAt: sender.indexPath)
  }
  
}
