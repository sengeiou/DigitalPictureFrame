//
//  FileLoader.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

final class FileLoader {
  typealias DecodeCompletion = ((_ digitalPictureFrameData: DigitalPictureFrameData?) -> ())
  
  
  static func loadJSONFile(fileName: String, decodeCompletion: DecodeCompletion) throws {
    guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
      throw FileLoaderError.fileNotFound(name: fileName)
    }
    
    do {
      let pathURL = URL(fileURLWithPath: path)
      let data = try Data(contentsOf: pathURL)
      let digitalPictureFrameData = try JSONDecoder().decode(DigitalPictureFrameData.self, from: data)
      
      decodeCompletion(digitalPictureFrameData)
    } catch {
      throw FileLoaderError.dataNotAvailable
    }
  }
  
}
