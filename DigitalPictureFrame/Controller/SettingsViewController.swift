//
//  SettingsViewController.swift
//  Digital Picture Frame
//
//  Created by Pawel Milek on 11/2/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController, TimePickerDelegate, TimeFrameSettingsCellDelegate {
  lazy private var timePicker: TimePicker = {
    let pickerViewHeight = CGFloat(220.0)
    let xPos = CGFloat(0)
    let yPos = view.frame.height
    let frame = CGRect(x: xPos, y: yPos, width: viewWidth, height: pickerViewHeight)
    let picker = TimePicker(presenterViewController: self, frame: frame)
    picker.delegate = self
    return picker
  }()
  
  private var modifiedItemIndexPath: IndexPath?
  private var items: [DigitalPictureFrameItem]?
  
  var settings: Settings? {
    didSet {
      createAndAssembleSettingsItem()
    }
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  deinit {
    print("Deinit SettingsViewController")
  }
}


// MARK: - Show/Hide Time Picker View
extension SettingsViewController {
  var viewHeight: CGFloat {
    return view.frame.height
  }
  
  var viewWidth: CGFloat {
    return view.frame.width
  }
  
  var pickerYPos: CGFloat {
    return viewHeight - timePicker.frame.height
  }
  

  
  
  func hideTimePickerView() {
    UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
      self.timePicker.frame = CGRect(x: 0, y: self.viewHeight, width: self.viewWidth, height: self.timePicker.frame.height)
    }, completion: { finished in
      self.timePicker.removeFromSuperview()
    })
  }
}

// MARK: - ViewSetupable protocol
extension SettingsViewController {
  
  override func setup() {
    super.setup()
    registerCells()
  }
  

  func createAndAssembleSettingsItem() {
    guard let settings = settings else { return }
    let general = SettingsGeneralItem(rgbLight: settings.rgbLight, randomQuotes: settings.randomQuotes, sleep: settings.sleep, reset: settings.reset)
    let timeFrame = SettingsTimeItem(timeFrame: settings.timeFrame)
    let userInfo = SettingsUserInfoItem(sideInfo: settings.sideInfo)
    let weatherZipcode = SettingsWeatherZipCodeItem(weatherZip: settings.weatherZip)
    items = [general, timeFrame, userInfo, weatherZipcode]
    
    dataSourceDelegate = DigitalPictureFrameDataSource(self, items: items!)
    tableView.dataSource = dataSourceDelegate
    tableView.delegate = dataSourceDelegate
  }
}



// MARK: - Register cells
extension SettingsViewController {
  
  func registerCells() {
    tableView.register(cell: GeneralSettingsTableViewCell.self)
    tableView.register(cell: UserInfoSettingsTableViewCell.self)
    tableView.register(cell: TimeFrameSettingsTableViewCell.self)
    tableView.register(cell: WeatherZipcodeSettingsTableViewCell.self)
  }
  
}


// MARK: - TimePickerDelegate protocol
extension SettingsViewController {
  
  func timePicker(_ timePicker: TimePicker, didPressDone sender: UIDatePicker) {
    guard let modifiedItemIndexPath = modifiedItemIndexPath else { return }
    guard let modifiedTimeFrameItem = dataSourceDelegate?.item(at: modifiedItemIndexPath) as? SettingsTimeItem else { return }
    guard let selectedTime = Date.date(sender.date) else { return }
    
    let time = modifiedTimeFrameItem.cells[modifiedItemIndexPath.row]
    time.value = selectedTime
    reloadRows(at: modifiedItemIndexPath)
    timePicker.dismiss()
  }
  
  func timePicker(_ timePicker: TimePicker, didPressCancel sender: UIDatePicker) {
    timePicker.dismiss()
  }
  
}


// MARK: - TimeFrameSettingsCellDelegate protocol
extension SettingsViewController {
  
  func timeFrameSettingsCell(_ cell: TimeFrameSettingsTableViewCell, didPressTimePickerButtonAt indexPath: IndexPath) {
    modifiedItemIndexPath = indexPath
    timePicker.present()
  }
  
}
