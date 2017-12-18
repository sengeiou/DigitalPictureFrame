//
//  AvailabilityMessageView.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit



class AvailabilityMessageView: UIView, ViewSetupable {
  static private var parentView: UIView?
  
  private var isVisible = false
  private var title: String?
  private var subtitle: String?
  private var labelHeight: CGFloat!
  private lazy var titleLabel: UILabel = {
    let xPos = CGFloat(0)
    let yPos = CGFloat(0)
    let width = self.frame.size.width
    
    let label = UILabel(frame: CGRect(x: xPos, y: yPos, width: width, height: self.labelHeight))
    label.text = self.title
    return label
  }()
  
  
  private lazy var subTitleLabel: UILabel = {
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


// MARK: - Show/Hide view
extension AvailabilityMessageView {
  
  private static var isViewVisible: Bool {
    guard let _ = parentView?.viewWithTag(EmbeddedViewTag.availabilityMessage.rawValue) else {
      return false
    }
    
    return true
  }
  
  
  static func show(on view: UIView, title: String, subtitle: String? = nil) {
    parentView = view
    guard !isViewVisible else { return }
    
    let messageHeight = CGFloat(25)
    let xPos = CGFloat(0)
    let yPos = (view.frame.size.height - (messageHeight * 2)) / 2
    let width = view.frame.size.width
    let titleMessage = NSLocalizedString("BLUETOOTH_CONNECTIVITY_LABEL_NO_PERIPHERALS_AVAILABLE_TITLE", comment: "")
    let subtitleMessage = NSLocalizedString("BLUETOOTH_CONNECTIVITY_LABEL_NO_PERIPHERALS_AVAILABLE_SUBTITLE", comment: "")
    
    let frame = CGRect(x: xPos, y: yPos, width: width, height: messageHeight * 2)
    let availabilityMessage = AvailabilityMessageView(frame: frame, titles: titleMessage, subtitleMessage)
    view.addSubview(availabilityMessage)
  }
  
  static func hide() {
    guard isViewVisible else { return }
    let availabilityMessageView = parentView?.viewWithTag(EmbeddedViewTag.availabilityMessage.rawValue)
    availabilityMessageView?.removeFromSuperview()
  }
  
}
