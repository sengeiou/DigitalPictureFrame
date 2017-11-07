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
    let pickerViewHeight = CGFloat(200.0)
    let yPos = view.frame.height
    let frame = CGRect(x: 0, y: yPos, width: viewWidth, height: pickerViewHeight)
    let picker = TimePicker(frame: frame)
    picker.delegate = self
    return picker
  }()
  
  private var items: [DigitalPictureFrameItem]? // modify!!
  
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
    unregisterNotifications()
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
  
  
  @objc func showTimePickerView() {
    UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
      self.timePicker.frame = CGRect(x: 0, y: self.pickerYPos, width: self.viewWidth, height: self.timePicker.frame.height)
    }, completion:nil)
    self.view.addSubview(self.timePicker)
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
  
    registerNotifications()
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


// MARK: - Add Notification Observer
extension SettingsViewController {
  
  func registerNotifications() {
    addNofificationObserverToShowTimePicker()
  }
  
  func unregisterNotifications() {
    removeNofificationObserverShowingTimePicker()
  }
  
  
  func addNofificationObserverToShowTimePicker() {
    NotificationCenter.default.addObserver(self, selector: #selector(SettingsViewController.showTimePickerView), name: NotificationName.showTimePicker.name, object: nil)
  }
  
  func removeNofificationObserverShowingTimePicker() {
    NotificationCenter.default.removeObserver(self, name: NotificationName.showTimePicker.name, object: nil)
  }
}


// MARK: - TimePickerDelegate protocol
extension SettingsViewController {
  
  func timePicker(_ timePicker: TimePicker, didSelectTime sender: UIDatePicker) {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    let time = formatter.string(from: sender.date)
    print(time)
  }
  
  func timePicker(_ timePicker: TimePicker, didPressDone sender: UIDatePicker) {
    hideTimePickerView()
    print("Done")
  }
  
  func timePicker(_ timePicker: TimePicker, didPressCancel sender: UIDatePicker) {
    hideTimePickerView()
    print("Cancel")
  }
  
}


// MARK: - TimeFrameSettingsCellDelegate protocol
extension SettingsViewController {
  
  func timeFrameSettingsCell(_ cell: TimeFrameSettingsTableViewCell, didPressTimePickerButtonAt indexPath: IndexPath) {
    showTimePickerView()
  }
  
}
