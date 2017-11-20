//
//  CustomTabBarDelegate.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

protocol CustomTabBarDelegate: class {
  func customTabBar(_ customTabBar: CustomTabBar, didSelectTabBarButtonAt index: Int)
}
