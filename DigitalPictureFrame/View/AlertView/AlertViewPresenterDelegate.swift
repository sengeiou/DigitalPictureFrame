//
//  AlertViewPresenterDelegate.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

protocol AlertViewPresenterDelegate: class {
  func alertView(_ alertViewPresenter: AlertViewPresenter, didSubmit result: String)
}
