//
//  FileLoaderError.swift
//  TableViewWithMultipleCellTypes
//
//  Created by Pawel Milek on 10/13/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

enum FileLoaderError: Error {
  case fileNotFound(name: String)
  case dataNotAvailable
}
