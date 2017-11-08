//
//  AvailabilityMessageView.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/2/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit



class AvailabilityMessageView: UIView, ViewSetupable {
  fileprivate var isVisible = false
  fileprivate var title: String?
  fileprivate var subtitle: String?
  fileprivate var labelHeight: CGFloat!
  fileprivate lazy var titleLabel: UILabel = {
    let xPos = CGFloat(0)
    let yPos = CGFloat(0)
    let width = self.frame.size.width
    
    let label = UILabel(frame: CGRect(x: xPos, y: yPos, width: width, height: self.labelHeight))
    label.text = self.title
    return label
  }()
  
  
  fileprivate lazy var subTitleLabel: UILabel = {
    let xPos = CGFloat(0)
    let yPos = self.titleLabel.frame.size.height
    let width = self.frame.size.width
    
    let label = UILabel(frame: CGRect(x: xPos, y: yPos, width: width, height: self.labelHeight))
    label.text = self.subtitle
    return label
  }()

  
  required init(frame: CGRect, titles: String ...) {
    super.init(frame: frame)
    self.title = titles.first
    self.subtitle = titles.count > 1 ? titles.last : nil
    self.labelHeight = frame.size.height / CGFloat(titles.count)
    setup()
    setupStyle()
    setupLayout()
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init?(coder aDecoder: NSCoder) not implemented")
  }
}



// MARK: - ViewSetupable protocol
extension AvailabilityMessageView {
  
  func setup() {
    tag = EmbeddedViewTag.availabilityMessage.rawValue
  }
  
  
  func setupStyle() {
    typealias MessageStyle = Style.AvailabilityMessageView
    titleLabel.textAlignment = MessageStyle.titleLabelTextAlignment
    titleLabel.font = MessageStyle.titleLabelFont
    subTitleLabel.textAlignment = MessageStyle.subTitleLabelTextAlignment
    subTitleLabel.font = MessageStyle.subTitleLabelFont
  }
  
  
  func setupLayout() {
    addSubview(titleLabel)
    addSubview(subTitleLabel)

    addConstraintsWith(format: "V:|[view0(\(labelHeight!))]-0-[view1(\(labelHeight!))]", forView: titleLabel, subTitleLabel)
    addConstraintsWith(format: "H:|[view0]|", forView: titleLabel)
    addConstraintsWith(format: "H:|[view0]|", forView: subTitleLabel)
  }
}
