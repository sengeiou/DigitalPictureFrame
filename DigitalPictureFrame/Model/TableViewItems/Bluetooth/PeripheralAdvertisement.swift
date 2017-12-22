//
//  PeripheralAdvertisement.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import CoreBluetooth

protocol PeripheralAdvertisement {
  var advertisementData: [String : Any] { get }
}
