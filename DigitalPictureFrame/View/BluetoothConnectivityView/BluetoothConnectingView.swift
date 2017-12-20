//
//  BluetoothConnectingView.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class BluetoothConnectingView: UIView {
  static private let sharedInstance = BluetoothConnectingView()
  
  private let contentView = UIView()
  private let titleLabel = UILabel()
  private let subtitleLabel = UILabel()
  private var scanningIndicator: NVActivityIndicatorView = {
    return NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 35, height: 35), type: .ballSpinFadeLoader, color: .white)
  }()
  
  fileprivate init() {
    super.init(frame: UIScreen.main.bounds)
    self.setup()
    self.setupLayout()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


// MARK: - ViewSetupable protocol
extension BluetoothConnectingView: ViewSetupable {
  
  func setup() {
    backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
    
    contentView.backgroundColor = UIColor.appleBlue
    contentView.layer.cornerRadius = 20
    
    titleLabel.textColor = .white
    titleLabel.font = UIFont.systemFont(ofSize: 19, weight: .medium)
    titleLabel.textAlignment = .center
    
    subtitleLabel.textColor = .white
    subtitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
    subtitleLabel.textAlignment = .center
    
    scanningIndicator.startAnimating()
  }
 
  func setupLayout() {
    setupConstraints()
  }
}


// MARK: -
extension BluetoothConnectingView {
  
  func setupConstraints() {
    contentView.addSubview(titleLabel)
    contentView.addSubview(subtitleLabel)
    contentView.addSubview(scanningIndicator)
    addSubview(contentView)
    
    contentView.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
    scanningIndicator.translatesAutoresizingMaskIntoConstraints = false
    
    let contentViewLeading = contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 80)
    let contentViewTrailing = contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -80)
    let contentViewHeight = contentView.heightAnchor.constraint(equalToConstant: 120)
    let contentViewCenterY = contentView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)
    NSLayoutConstraint.activate([contentViewLeading, contentViewTrailing, contentViewHeight, contentViewCenterY])
    
    let titleLabelTopConstraint = titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20)
    let titleLabelCenterXConstraint = titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
    let titleLabelWidthConstraint = titleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 20)
    NSLayoutConstraint.activate([titleLabelTopConstraint, titleLabelCenterXConstraint, titleLabelWidthConstraint])
    
    let subtitleLabelTopConstraint = subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10)
    let subtitleLabelCenterXConstraint = subtitleLabel.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor)
    let subtitleLabelWidthConstraint = subtitleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 20)
    NSLayoutConstraint.activate([subtitleLabelTopConstraint, subtitleLabelCenterXConstraint, subtitleLabelWidthConstraint])
    
    let scanningIndicatorViewTopConstraint = scanningIndicator.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 5)
    let scanningIndicatorViewCenterXConstraint = scanningIndicator.centerXAnchor.constraint(equalTo: subtitleLabel.centerXAnchor)
    let scanningIndicatorViewWidthConstraint = scanningIndicator.widthAnchor.constraint(equalToConstant: 50)
    NSLayoutConstraint.activate([scanningIndicatorViewTopConstraint, scanningIndicatorViewWidthConstraint, scanningIndicatorViewCenterXConstraint])
  }
  
}


// MARK: - Show/Hide view
extension BluetoothConnectingView {
  
  static func show() {
    if let window = UIApplication.shared.keyWindow {
      sharedInstance.titleLabel.text = NSLocalizedString("BLUETOOTH_CONNECTING_VIEW_LABEL_TITLE_CONNECT", comment: "")
      window.addSubview(sharedInstance)
    }
  }
  
  
  static func showWithSubtitle(_ title: String) {
    if let window = UIApplication.shared.keyWindow {
      sharedInstance.titleLabel.text = NSLocalizedString("BLUETOOTH_CONNECTING_VIEW_LABEL_TITLE_CONNECT", comment: "")
      sharedInstance.subtitleLabel.text = title
      window.addSubview(sharedInstance)
    }
  }

  static func hide() {
    sharedInstance.removeFromSuperview()
  }
  
  static func conectingInProgressWith(title: String) {
    sharedInstance.titleLabel.text = title
  }
  
}
