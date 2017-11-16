//
//  Date+Utility.swift
//  iOS-CNH-MobileDealerConnect
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

extension Date {
  
  fileprivate static var tzdFormat: String {
    let format = "yyyy-MM-dd'T'HH:mm:ssZ"
    return format
  }
  
  static func date(_ date: Date) -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = Date.tzdFormat
    return dateFormatter.string(from: date)
  }
  

  static func shortTime(from dateString: String) -> String {
    let isoFormatter = ISO8601DateFormatter()
    let date = isoFormatter.date(from: dateString)!
    
    let formatter = DateFormatter()
    formatter.dateStyle = .none
    formatter.timeStyle = .short
    return formatter.string(from: date)
  }
  
}
