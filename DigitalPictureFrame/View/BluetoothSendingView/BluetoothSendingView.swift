//
//  BluetoothSendingView.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 12/21/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit
import UICircularProgressRing

class BluetoothSendingView: UIView {
  static private(set) var sharedInstance = BluetoothSendingView()
  
  private var progressRing: UICircularProgressRingView = {
    let ring = UICircularProgressRingView(frame: .zero)
    ring.maxValue = 100
    ring.ringStyle = .ontop
    ring.outerRingColor = UIColor.appleBlue
    ring.outerRingWidth = 20
    ring.innerRingWidth = 10
    ring.innerRingColor = .white
    ring.fontColor = .white
    ring.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    return ring
  }()
  
  
  var progress: Float = 0 {
    didSet {
      let ringProgress = Int(progress * 100)
      progressRing.setProgress(value: CGFloat(ringProgress), animationDuration: 1.5)
    }
  }
  
  
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
extension BluetoothSendingView: ViewSetupable {
  
  func setup() {
    backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
  }
  
  func setupLayout() {
    setupConstraints()
  }
}


// MARK: - Setup constraints
extension BluetoothSendingView {
  
  func setupConstraints() {
    addSubview(progressRing)
    progressRing.translatesAutoresizingMaskIntoConstraints = false

    let progressRingCenterYConstraint = progressRing.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)
    let progressRingCenterXConstraint = progressRing.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
    let progressRingWidthConstraint = progressRing.widthAnchor.constraint(equalToConstant: 125)
    let progressRingHeightConstraint = progressRing.heightAnchor.constraint(equalToConstant: 125)
    NSLayoutConstraint.activate([progressRingWidthConstraint, progressRingHeightConstraint, progressRingCenterYConstraint, progressRingCenterXConstraint])
  }
  
}


// MARK: - Show/Hide view
extension BluetoothSendingView {
  
  static func show() {
    if let window = UIApplication.shared.keyWindow {
      sharedInstance.progress = 0
      window.addSubview(sharedInstance)
    }
  }
  
  static func hide() {
    sharedInstance.removeFromSuperview()
  }
  
}
