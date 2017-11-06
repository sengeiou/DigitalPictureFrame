//
//  GeneralSettingsSection.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/3/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

protocol GeneralSettingsSection {
  var rgbLight: Bool { get set }
  var randomQuotes: Bool { get set }
  var sleep: Bool { get set }
  var reset: Bool { get set }
}
