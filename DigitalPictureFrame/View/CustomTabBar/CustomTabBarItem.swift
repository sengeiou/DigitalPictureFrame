//
//  CustomTabBarItem.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit

final class CustomTabBarItem: UIButton {
  private let titleFont = UIFont.systemFont(ofSize: 8, weight: .ultraLight)
  private var iconView: UIImageView!
  private var image: UIImage?
  
  override var isSelected: Bool {
    didSet {
      iconView.tintColor = isSelected ? UIColor.appleBlue : UIColor.lightGray
      
      let titleTintColor = (isSelected ? UIColor.appleBlue : UIColor.lightGray)
      let attributes = [NSAttributedStringKey.font: self.titleFont, NSAttributedStringKey.foregroundColor: titleTintColor]
      let attributedtitle = NSAttributedString(string: self.titleLabel?.text ?? "", attributes: attributes)
      self.setAttributedTitle(attributedtitle, for: .normal)
    }
  }

  var delegate: CustomTabBarItemDelegate?
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  convenience init(image: UIImage, title: String? = nil) {
    self.init(frame: .zero)
    
    self.image = image
    if let title = title {
      let attributes = [NSAttributedStringKey.font: titleFont, NSAttributedStringKey.foregroundColor: UIColor.lightGray]
      let attributedtitle = NSAttributedString(string: title, attributes: attributes)
      self.setAttributedTitle(attributedtitle, for: .normal)
      self.titleEdgeInsets = UIEdgeInsetsMake(39, 0, 0, 0)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}


// MARK: - ViewSetupable protocol
extension CustomTabBarItem: ViewSetupable {
  
  func setup() {
    guard let image = image else { fatalError("Add images to tabbar items") }
    let xPos = (frame.width - image.size.width) / 2
    let yPos = (frame.height - image.size.height) / 2
    let iconFrame = CGRect(x: xPos, y: yPos, width: frame.width, height: frame.height)
    
    addTarget(self, action: #selector(CustomTabBarItem.barItemTapped(_:)), for: .touchUpInside)
    iconView = UIImageView(frame: iconFrame)
    iconView.image = image
    iconView.tintImage(color: UIColor.lightGray)
    iconView.sizeToFit()
    addSubview(iconView)
  }

}

// MARK: Actions
extension CustomTabBarItem {
  
  @objc func barItemTapped(_ sender: UIButton) {
    delegate?.customTabBarItemDidSelect(self)
    updateState()
  }
  
  
  private func updateState() {
    isSelected = true
  }
  
}
