//
//  LogFooterView.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit

class LogFooterView: UIView {
  @IBOutlet var contentView: UIView!
  @IBOutlet weak var logButton: UIButton!
  

  private var logAction: (() -> ())?
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setup()
    self.setupLayout()
    self.setupStyle()
  }

  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.setup()
    self.setupLayout()
    self.setupStyle()
  }
}


// MARK: - ViewSetupable protocol
extension LogFooterView: ViewSetupable {
  
  func setup() {
    loadFromNib()
    logButton.addTarget(self, action: #selector(LogFooterView.logButtonPressed(_:)), for: .touchUpInside)
  }
  
  func setupStyle() {
    typealias LogViewStyle = Style.LogFooterView
    backgroundColor = LogViewStyle.defaultBackgroundColor
    logButton.backgroundColor = LogViewStyle.defaultBackgroundColor
    logButton.titleLabel?.font = LogViewStyle.logButtonTitleFont
    logButton.setTitle("Log", for: .normal)
  }
  
  func setupLayout() {
    setupConstraints()
  }
}



// MARK: - Load from Nib
private extension LogFooterView {
  
  func loadFromNib() {
    Bundle.main.loadNibNamed(LogFooterView.nibName, owner: self, options: nil)
    addSubview(contentView)
    contentView.frame = self.bounds
    contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
  }
  
}


// MARK: - Setup constraints
extension LogFooterView {
  
  func setupConstraints() {
    addSubview(logButton)
    logButton.translatesAutoresizingMaskIntoConstraints = false

    let logButtonLeading = logButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0)
    let logButtonTrailing = logButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0)
    let logButtonTopConstraint = logButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
    let logButtonBottomConstraint = logButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
    NSLayoutConstraint.activate([logButtonLeading, logButtonTrailing, logButtonTopConstraint, logButtonBottomConstraint])
  }
  
}



// MARK: - Actions
extension LogFooterView {
  
  @objc func logButtonPressed(_ sender: UIButton?) {
    if let logAction = logAction {
      logAction()
    }
  }
  
  func logButtonAction(_ action: @escaping (() -> ())) {
    logAction = action
  }
}
