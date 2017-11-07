//
//  Date+Utility.swift
//  iOS-CNH-MobileDealerConnect
//
//  Created by Pawel Milek on 3/14/17.
//  Copyright © 2017 Reply Inc. All rights reserved.
//

import Foundation


extension Date {
  fileprivate static var enLocaleDateFormat: String! {
    let currentLocale = Locale.current.identifier
    
    switch currentLocale {
    case "en_US":
      let usDateFormat = DateFormatter.dateFormat(fromTemplate: "MMddyyyy", options: 0, locale: Locale(identifier: "en-US"))
      return usDateFormat
      
    default:
      let gbDateFormat = DateFormatter.dateFormat(fromTemplate: "MMddyyyy", options: 0, locale: Locale(identifier: "en-GB"))
      return gbDateFormat
    }
  }
  
  fileprivate static var tzdFormat: String {
    let format = "yyyy-MM-dd'T'HH:mm:ssZ"
    return format
  }
  
  
  
  static func date(_ fromString: String, withDateFormat format: String = "yyyyMMdd") -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    
    return dateFormatter.date(from: fromString)
  }
  
  
  static func dateWithTimeZone(_ fromString: String) -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = enLocaleDateFormat
    
    let date = dateFormatter.date(from: fromString)
    dateFormatter.dateFormat = Date.tzdFormat
    
    return dateFormatter.string(from: date!)
  }
  
  
  static func date(fromStringWithTimeZone stringDate: String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = tzdFormat
    return dateFormatter.date(from: stringDate)
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
    formatter.timeStyle = .medium
    return formatter.string(from: date)
  }
  
  
  init?(fromString: String?) {
    guard let stringDate = fromString else { return nil }

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = Date.enLocaleDateFormat
    
    let date = dateFormatter.date(from: stringDate)!
    self.init(timeInterval: 0, since: date)
  }
}
