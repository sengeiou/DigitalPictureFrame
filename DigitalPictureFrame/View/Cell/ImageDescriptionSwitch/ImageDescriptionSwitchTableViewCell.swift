//
//  ImageDescriptionSwitchTableViewCell.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/2/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit
import Foundation

class ImageDescriptionSwitchTableViewCell: UITableViewCell { //, DigitalPictureFrameCellSetupable {
  @IBOutlet weak var descImageView: UIImageView!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var onOffSwitch: UISwitch!
  
//  var rowInSection: Int?
//  var item: DigitalPictureFrameItem? {
//    didSet {
//      switch item {
//      case is UserItem:
//        guard let userItem = item as? UserItem, let row = rowInSection else { return }
//        let user = userItem.cells[row].entity
//
//        descriptionLabel.text = user.name
//        onOffSwitch.isOn = user.enabled
//
//        if let imageData = Data(base64Encoded: user.image) {
//          let userImage = UIImage(data: imageData)
//          descImageView.image = userImage
//        }
//
//      case is SettingsGeneralItem:
//        guard let settingsItem = item as? SettingsGeneralItem, let row = rowInSection else { return }
////        descriptionLabel.text = settingsItem
////        onOffSwitch.isOn = user.enabled
//
//      default:
//        break
//      }
//
//    }
//  }
  
  override func awakeFromNib() {
    super.awakeFromNib()

    descImageView.roundThumbnail()
  }
  
}

