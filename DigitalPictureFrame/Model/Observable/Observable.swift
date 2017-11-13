//
//  Observable.swift
//  iOS-CNH-MobileDealerConnect
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation


protocol Observable {
  associatedtype T
  
  var value: T { get set }
  
  func subscribe(_ observer: AnyObject, completionHnadler: @escaping ( _ newValue: T, _ oldValue: T) -> ())
  func unsubscribe(_ observer: AnyObject)
}
