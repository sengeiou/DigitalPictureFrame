//
//  TimePickerView.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit

class TimePickerView: UIView, ViewSetupable, PickerViewPresentable {
  @IBOutlet var contentView: UIView!
  @IBOutlet weak var picker: UIDatePicker!
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var doneButton: UIButton!
  
  var presenterViewController: UIViewController?
  var fadeView: UIView?
  weak var delegate: TimePickerViewDelegate?
  
  
  convenience init(presenter: UIViewController, frame: CGRect) {
    self.init(frame: frame)
    self.presenterViewController = presenter
    self.fadeView = UIView(frame: presenterViewController!.view.frame)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
    setupStyle()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
    setupStyle()
  }
}


// MARK: - ViewSetupable protocol
extension TimePickerView {
  
  func setup() {
    loadFromNib()
  }
  
  func setupStyle() {
    picker.datePickerMode = .time
    picker.backgroundColor = .white
    contentView.backgroundColor = .groupGray
  }
  
}


// MARK: - Load from Nib
private extension TimePickerView {
  
  func loadFromNib() {
    Bundle.main.loadNibNamed(TimePickerView.reuseIdentifier, owner: self, options: nil)
    addSubview(contentView)
    contentView.frame = self.bounds
    contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
  }
  
}
