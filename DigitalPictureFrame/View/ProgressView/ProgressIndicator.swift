//
//  ProgressIndicator.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/7/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit

final class ProgressIndicator: UIVisualEffectView, ViewSetupable {
  private let activityIndictor: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
  private let label: UILabel = UILabel()
  private let blurEffect = UIBlurEffect(style: .light)
  private let vibrancyView: UIVisualEffectView
  private var text: String? {
    didSet {
      label.text = text
    }
  }
  
  
  init(text: String) {
    self.text = text
    self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
    super.init(effect: blurEffect)
    self.setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    self.text = ""
    self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
    super.init(coder: aDecoder)
    self.setup()
  }
  
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    setupLayout()
  }
  
  
  func show() {
    self.isHidden = false
  }
  
  func hide() {
    self.isHidden = true
  }
}


// MARK: - ViewSetupable protocol
extension ProgressIndicator {
  
  func setup() {
    contentView.addSubview(vibrancyView)
    contentView.addSubview(activityIndictor)
    contentView.addSubview(label)
    activityIndictor.startAnimating()
  }
  
  
  func setupLayout() {
    guard let superview = self.superview else { return }
    let width = superview.frame.size.width / 2.3
    let height: CGFloat = 50.0
    let frame: (x: CGFloat, y: CGFloat) = (superview.frame.size.width / 2 - width / 2, superview.frame.height / 2 - height / 2)
    
    self.frame = CGRect(x: frame.x, y: frame.y, width: width, height: height)
    vibrancyView.frame = self.bounds
    
    let indicatorSize = CGSize(width: 40, height: 40)
    let indictor: (x: CGFloat, y: CGFloat) = (5, height / 2 - indicatorSize.height / 2)
    activityIndictor.frame = CGRect(x: indictor.x, y: indictor.y, width: indicatorSize.width, height: indicatorSize.height)
    
    layer.cornerRadius = 8.0
    layer.masksToBounds = true
    label.text = text
    label.textAlignment = NSTextAlignment.center
    label.frame = CGRect(x: indicatorSize.width, y: 0, width: width - indicatorSize.width - 15, height: height)
    label.textColor = UIColor.gray
    label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
  }
}
