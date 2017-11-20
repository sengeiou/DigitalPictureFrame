//
//  UserPickerView.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit

class UserPickerView: UIView, ViewSetupable, UIPickerViewDataSource, UIPickerViewDelegate, PickerViewPresentable {
  @IBOutlet var contentView: UIView!
  @IBOutlet weak var picker: UIPickerView!
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var doneButton: UIButton!

  private var users: [User]? {
    return DatabaseManager.shared().users
  }
  var presenterViewController: UIViewController?
  var fadeView: UIView?
  weak var delegate: UserPickerViewDelegate?
  
  
  convenience init(presenter: UIViewController, frame: CGRect) {
    self.init(frame: frame)
    self.presenterViewController = presenter
    self.fadeView = UIView(frame: CGRect(x: viewXPos, y: viewYPos, width: viewWidth, height: viewHeight))
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
extension UserPickerView {
  
  func setup() {
    loadFromNib()
    picker.dataSource = self
    picker.delegate = self
  }
  
  func setupStyle() {
    picker.backgroundColor = .white
    contentView.backgroundColor = .groupGray
  }
  
}


// MARK: - Load from Nib
private extension UserPickerView {
  
  func loadFromNib() {
    Bundle.main.loadNibNamed(UserPickerView.reuseIdentifier, owner: self, options: nil)
    addSubview(contentView)
    contentView.frame = self.bounds
    contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
  }
  
}


// MARK: - Item at index
extension UserPickerView {
  
  func item(at index: Int) -> User? {
    return users?[index]
  }
}


// MARK: - UIPickerViewDataSource protocol
extension UserPickerView {
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return users?.count ?? 0
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    guard let user = item(at: row) else { return "" }
    return user.name
  }
  
}


// MARK: - UIPickerViewDelegate protocol
extension UserPickerView {
  
  func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
    return 45
  }
  
}
