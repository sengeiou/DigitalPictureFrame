//
//  Observer.swift
//  iOS-CNH-MobileDealerConnect
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation


final class Observer<T>: Observable {
  typealias ObserverCompletionHandler = (_ newValue: T, _ oldValue: T) -> ()
  typealias ObserversEntry = (observer: AnyObject, block: ObserverCompletionHandler)
  
  fileprivate var observers: [ObserversEntry]

  // MARK: - Notify 'observers' that the value changed
  var value: T {
    didSet {
      observers.forEach { (entry: ObserversEntry) in
        let (_, completionHandler) = entry
        completionHandler(value, oldValue)
      }
    }
  }
  
  init(value: T) {
    self.value = value
    observers = []
  }
  
}


// MARK: - Add/Remove observer tuples
extension Observer {
  
  func subscribe(_ observer: AnyObject, completionHnadler: @escaping ObserverCompletionHandler) {
    let newObserver: ObserversEntry = (observer: observer, block: completionHnadler)
    observers.append(newObserver)
  }
  
  func unsubscribe(_ observer: AnyObject) {
    let filteredObserver = observers.filter { nextObserver in
      let (owner, _) = nextObserver
      return owner !== observer
    }
    
    observers = filteredObserver
  }
  
}

