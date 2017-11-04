//
//  NetworkResultType.swift
//  TableViewWithMultipleCellTypes
//
//  Created by Pawel Milek on 10/19/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

enum NetworkResultType<T, E> where E: Error {
  case success(T)
  case failure(E)
}
