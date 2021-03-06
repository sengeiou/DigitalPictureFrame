//
//  UserPickerViewDelegate.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit

protocol UserPickerViewDelegate: class {
  func userPicker(_ userPickerView: UserPickerView, didPressDone picker: UIPickerView)
  func userPicker(_ userPickerView: UserPickerView, didPressCancel picker: UIPickerView)
}
