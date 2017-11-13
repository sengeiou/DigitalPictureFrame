//
//  FileLoaderError.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

enum FileLoaderError: Error {
  case fileNotFound(name: String)
  case dataNotAvailable
}
