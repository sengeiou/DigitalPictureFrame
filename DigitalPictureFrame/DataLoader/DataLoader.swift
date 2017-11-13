//
//  DataLoader.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

final class DataLoader {
  typealias DecodeCompletion = ((_ profile: User?)->())
  
  static func loadUserFromJSONFile(fileName: String, decodeCompletion: DecodeCompletion) throws {
    guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
      throw FileLoaderError.fileNotFound(name: fileName)
    }
    
    do {
      let pathURL = URL(fileURLWithPath: path)
      let data = try Data(contentsOf: pathURL)
      let profile = try JSONDecoder().decode(User.self, from: data)
      decodeCompletion(profile)
    } catch let error {
      throw error
    }
  }
  
}
