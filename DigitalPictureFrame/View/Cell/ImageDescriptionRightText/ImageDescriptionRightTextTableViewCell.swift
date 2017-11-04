//
//  ImageDescriptionRightTextTableViewCell.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/2/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit

class ImageDescriptionRightTextTableViewCell: UITableViewCell {//, DigitalPictureFrameCellSetupable {
  @IBOutlet weak var descImageView: UIImageView!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var rightTextLabel: UILabel!
//
//  var rowInSection: Int?
//  var item: DigitalPictureFrameItem? {
//    didSet {
//      //    if let data = Data(base64Encoded: base64) {
//      //      let image = UIImage(data: data)
//      //    }
//    }
//  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    descImageView.roundThumbnail()
  }
}
