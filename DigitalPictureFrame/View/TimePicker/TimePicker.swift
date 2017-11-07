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
  
  
  private weak var presenterViewController: UIViewController!
  lazy private var fadeView: UIView = {
    let view = UIView(frame: self.presenterViewController.view.frame)
    return view
  }()
  
  weak var delegate: TimePickerDelegate?
  
  private var viewHeight: CGFloat {
    return presenterViewController.view.frame.height
  }
  
  private var viewWidth: CGFloat {
    return presenterViewController.view.frame.width
  }
  
  
  convenience init(presenterViewController: UIViewController, frame: CGRect) {
    self.init(frame: frame)
    self.presenterViewController = presenterViewController
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
  
  
  deinit {
    print("deinit TimePicker")
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
    datePicker.backgroundColor = .white
    contentView.backgroundColor = .groupGray
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



// MARK: - Present and dismiss view
extension TimePicker {
  
  func present() {
    let pickerYPos = viewHeight - frame.height
    UIApplication.shared.keyWindow!.addSubview(fadeView)
    fadeView.backgroundColor = UIColor.black.withAlphaComponent(0)
    
    UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
      self.frame = CGRect(x: 0, y: pickerYPos, width: self.viewWidth, height: self.frame.height)
      self.fadeView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    })
    
    fadeView.addSubview(self)
  }
  
  func dismiss() {
    fadeView.backgroundColor = UIColor.black.withAlphaComponent(0)
    UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
      self.frame = CGRect(x: 0, y: self.viewHeight, width: self.viewWidth, height: self.frame.height)
    }, completion: { finished in
      self.removeFromSuperview()
      self.fadeView.removeFromSuperview()
    })
  }
}
