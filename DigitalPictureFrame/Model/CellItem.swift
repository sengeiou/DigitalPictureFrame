//
//  CellItem.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/2/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit

final class CellItem {
  private var editObserver: Observer<Any>
  var thumbnailImageName: String
  var description: String
  var value: Any {
    didSet {
      editObserver.value = value
    }
  }
  
  init(thumbnailImageName: String, description: String, value: Any) {
    self.thumbnailImageName = thumbnailImageName
    self.description = description
    self.value = value
    self.editObserver = Observer<Any>(value: value)
  }
}


// MARK: - Subscribe observer
extension CellItem {
  
  func subscribe(observer: AnyObject, completionHnadler: @escaping Observer<Any>.ObserverCompletionHandler) {
    editObserver.subscribe(observer, completionHnadler: completionHnadler)
  }
  
  
  func unsubscribe(observer: AnyObject) {
    editObserver.unsubscribe(observer)
  }
  
}
