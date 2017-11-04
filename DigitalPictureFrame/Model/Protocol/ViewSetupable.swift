//
//  ViewSetupable.swift
//  ARPuzzle15
//
//  Created by Pawel Milek on 9/18/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

@objc protocol ViewSetupable {
  func setup()
  @objc optional func setupStyle()
  @objc optional func setupLayout()
}
