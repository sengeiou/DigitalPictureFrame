//
//  StoryboardIdentifiable.swift
//  ARPuzzle15
//
//  Created by Pawel Milek on 10/24/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit

protocol StoryboardIdentifiable {
  static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
  static var storyboardIdentifier: String {
    return String(describing: self)
  }
}
