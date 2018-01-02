//
//  Logger.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

struct Logger {
  static private var data: [String] = []
  
  static var stringRepresentation: String {
    return data.flatMap({$0}).joined(separator: "\n")
  }
}


// MARK: - log
extension Logger {
  
  static func log(message: String, event: LogEventType, fileName: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
    func extractFileName(from filePath: String) -> String {
      let components = filePath.components(separatedBy: "/")
      return components.isEmpty ? "" : components.last!
    }
    
    let date = String(describing: Date.dateToString(Date())!)
    let fileName = extractFileName(from: fileName)
    let composedMessage = "\(date) \(event.rawValue)[\(fileName)]:\(line) \(column) \(funcName) -> \(message)"
    
    #if DEBUG
      print(composedMessage)
    #endif
  }
  
  
  static func logInfo(message: String) {
    let date = String(describing: Date.dateToString(Date())!)
    let event = LogEventType.info.rawValue
    let composedMessage = "\(date) \(event): \(message)"

    data.append(composedMessage)
  }
  
}
