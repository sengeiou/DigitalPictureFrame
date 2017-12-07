//
//  AccessVerifierError.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

enum AccessVerifierError: Error {
  case accessDenied
  case dataNotAvailable(description: String)
}
