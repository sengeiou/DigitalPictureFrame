//
//  Fragmenter.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

struct Fragmenter {
  static let notifyMaximumTransferUnit = 20 // 20 bytes
  static let carriageReturn = "\r\n"
  
  static private var shared = Fragmenter()
  
  static var totalSize: Int {
    return shared.data.count
  }
  
  private var data: Data
  private var fragmentedData: [Data]
  
  
  private init() {
    self.data = Data()
    self.fragmentedData = []
  }
  
  
  static func fragmentise(data: Data) -> [Data] {
    var isAppendingCarriageReturn = false
    var appendDataLength = 0
    shared.data = data
    shared.fragmentedData = []
    
    repeat {
      var bytesFragment = totalSize - appendDataLength
      // Can't be longer than 20 bytes
      if bytesFragment > Fragmenter.notifyMaximumTransferUnit {
        bytesFragment = Fragmenter.notifyMaximumTransferUnit
      }
      
      let chunk: Data = data.withUnsafeBytes {(body: UnsafePointer<UInt8>) in
        return Data(bytes: body + appendDataLength, count: bytesFragment)
      }
      
      shared.fragmentedData.append(chunk)
      appendDataLength += bytesFragment
      
      if appendDataLength >= totalSize {
        isAppendingCarriageReturn = true
        let endOfMessage = Fragmenter.carriageReturn.data(using: String.Encoding.utf8)!
        shared.fragmentedData.append(endOfMessage)
      }
      
    } while (isAppendingCarriageReturn == false)

    return shared.fragmentedData
  }
}
