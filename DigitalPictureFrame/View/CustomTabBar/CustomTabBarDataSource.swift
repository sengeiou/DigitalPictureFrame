//
//  CustomTabBarDataSource.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit

protocol CustomTabBarDataSource: class {
  func tabBarItems(in CustomTabBar: CustomTabBar) -> [CustomTabBarItem]
}
