//
//  Style.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit

struct Style {

  // MARK: - AvailabilityMessageView
  struct AvailabilityMessageView {
    static let titleLabelTextAlignment = NSTextAlignment.center
    static let titleLabelFont = UIFont.systemFont(ofSize: 20, weight: .bold)
    static let subTitleLabelFont = UIFont.systemFont(ofSize: 15, weight: .light)
    static let subTitleLabelTextAlignment = NSTextAlignment.center
  }
  
  // MARK: - TimePickerView
  struct TimePickerView {
    static var itemNameLabelFont = UIFont.systemFont(ofSize: 18, weight: .regular)
    static var pickerItemLabelFont = UIFont.systemFont(ofSize: 18, weight: .light)
    static var pickerItemLabelTextAlignment = NSTextAlignment.center
    static var pickerItemLabelLineBreakMode = NSLineBreakMode.byWordWrapping
    static var pickerItemLabelNumberOfLines = 0
  }

  
  // MARK: - BluetoothPeripheralViewController
  struct BluetoothPeripheralVC {
    static let navigationBarBackgroundColor = UIColor.groupGray
    static let navigationBarTextColor = UIColor.appleBlue
    
    static let peripheralNameLabelFont = UIFont.systemFont(ofSize: 25, weight: .regular)
    static let peripheralNameLabelNumberOfLines = 1
    static let peripheralNameLabelAlignment = NSTextAlignment.left
    
    static let peripheralUUIDLabelFont = UIFont.systemFont(ofSize: 16, weight: .ultraLight)
    static let peripheralUUIDLabelNumberOfLines = 1
    static let peripheralUUIDLabelAlignment = NSTextAlignment.left
    
    static let connectedLabelFont = UIFont.systemFont(ofSize: 18, weight: .bold)
    static let connectedLabelTextColor = UIColor.red
    static let connectedLabelNumberOfLines = 1
    static let connectedLabelAlignment = NSTextAlignment.left
  }
  
  
  // MARK: - BluetoothConnectivityTableViewHeader
  struct BluetoothConnectivityTableViewHeader {
    static let defaultBackgroundColor = UIColor.white
    static let titleLabelFont = UIFont.systemFont(ofSize: 18, weight: .bold)
    static let titleLabelTextColor = UIColor.black
    static let titleLabelTextAlignment = NSTextAlignment.left
    static let titleLabelNumberOfLines = 1
  }
  
  
  // MARK: - BluetoothScanningTableViewCell
  struct BluetoothScanningCell {
    static let defaultBackgroundColor = UIColor.white
    
    static let peripheralNameLabelFont = UIFont.systemFont(ofSize: 18, weight: .regular)
    static let peripheralNameLabelTextColor = UIColor.black
    static let peripheralNameLabelAlignment = NSTextAlignment.left
    static let peripheralNameLabelNumberOfLines = 1
    
    static let signalStrengthLabelFont = UIFont.systemFont(ofSize: 10, weight: .regular)
    static let signalStrengthLabelAlignment = NSTextAlignment.center
    static let signalStrengthLabelNumberOfLines = 1
    
    static let serviceDescriptionLabelFont = UIFont.systemFont(ofSize: 12, weight: .ultraLight)
    static let serviceDescriptionLabelAlignment = NSTextAlignment.left
    static let serviceDescriptionLabelNumberOfLines = 1
    
    static let connectButtonTitleFont = UIFont.systemFont(ofSize: 15, weight: .regular)
  }
  
  
  // MARK: - BluetoothPeripheralTableViewCell
  struct BluetoothPeripheralCell {
    static let defaultBackgroundColor = UIColor.white
    
    static let serviceTitleLabelFont = UIFont.systemFont(ofSize: 16, weight: .regular)
    static let serviceTitleLabelTextColor = UIColor.black
    static let serviceTitleLabelAlignment = NSTextAlignment.left
    static let serviceTitleLabelNumberOfLines = 1
    
    static let serviceDescriptionLabelFont = UIFont.systemFont(ofSize: 15, weight: .ultraLight)
    static let serviceDescriptionLabelTextColor = UIColor.black
    static let serviceDescriptionLabelAlignment = NSTextAlignment.left
    static let serviceDescriptionLabelNumberOfLines = 1
    
    static let sendButtonTitleFont = UIFont.systemFont(ofSize: 15, weight: .regular)
    static let listenNotificationsButtonTitleFont = UIFont.systemFont(ofSize: 15, weight: .regular)
    static let buttonBoarderColor = UIColor.appleBlue.cgColor
  }
  
  
  // MARK: - BluetoothPeripheralTableViewCell
  struct BluetoothPeripheralAdvertisementCell {
    static let defaultBackgroundColor = UIColor.white
    
    static let nameLabelFont = UIFont.systemFont(ofSize: 16, weight: .regular)
    static let nameLabelTextColor = UIColor.black
    static let nameLabelAlignment = NSTextAlignment.left
    static let nameLabelNumberOfLines = 1
    
    static let descriptionLabelFont = UIFont.systemFont(ofSize: 15, weight: .ultraLight)
    static let descriptionLabelTextColor = UIColor.black
    static let descriptionLabelAlignment = NSTextAlignment.left
    static let descriptionLabelNumberOfLines = 1
  }
  
  // MARK: - BluetoothPeripheralDeviceInfoTableViewCell
  struct BluetoothPeripheralDeviceInfoCell {
    static let defaultBackgroundColor = UIColor.white
    
    static let nameLabelFont = UIFont.systemFont(ofSize: 16, weight: .regular)
    static let nameLabelTextColor = UIColor.black
    static let nameLabelAlignment = NSTextAlignment.left
    static let nameLabelNumberOfLines = 1
    
    static let descriptionLabelFont = UIFont.systemFont(ofSize: 15, weight: .ultraLight)
    static let descriptionLabelTextColor = UIColor.black
    static let descriptionLabelAlignment = NSTextAlignment.left
    static let descriptionLabelNumberOfLines = 1
  }
  
  
  // MARK: - PopupCentralManagerStateView
  struct PopupCentralManagerStateView {
    static var backgroundColor: UIColor { return UIColor.appleBlue }
    static let messageLabelFont = UIFont.systemFont(ofSize: 12, weight: .bold)
    static let messageLabelTextColor = UIColor.white
    static let messageLabelTextAlignment = NSTextAlignment.center
    static let messageLabelNumberOfLines = 2
  }
}
