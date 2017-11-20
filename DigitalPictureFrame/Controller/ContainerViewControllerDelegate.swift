//
//  ContainerViewControllerDelegate.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/19/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

protocol ContainerViewControllerDelegate: class {
  func containerViewController(_ containerViewController: ContainerViewController, didSelectPageAt index: Int)
}
