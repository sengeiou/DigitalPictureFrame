//
//  TimePicker.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/6/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit

class TimePicker: UIView, ViewSetupable {
  @IBOutlet var contentView: UIView!
  @IBOutlet weak var datePicker: UIDatePicker!
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var doneButton: UIButton!
  
  weak var delegate: TimePickerDelegate?
  
  
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
extension TimePicker {
  
  func setup() {
    loadFromNib()
    datePicker.addTarget(self, action: #selector(TimePicker.timeDidChange), for: UIControlEvents.valueChanged)
  }
  
  func setupStyle() {
    datePicker.datePickerMode = .time
    datePicker.backgroundColor = UIColor.white
    contentView.backgroundColor = .red
  }
  
}


// MARK: - Load from Nib
private extension TimePicker {
  
  func loadFromNib() {
    Bundle.main.loadNibNamed(TimePicker.reuseIdentifier, owner: self, options: nil)
    addSubview(contentView)
    contentView.frame = self.bounds
    contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
  }
  
}
