//
//  SettingsViewController.swift
//  Digital Picture Frame
//
//  Created by Pawel Milek on 11/2/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController, ListPickerViewDelegate, TimeFrameSettingsCellDelegate, WeatherZipcodeSettingsCellDelegate, AlertViewPresenterDelegate, UserInfoSettingsCellDelegate, UITextFieldDelegate {
  lazy private var timePicker: TimePicker = {
    let pickerViewHeight = CGFloat(220.0)
    let xPos = CGFloat(0)
    let yPos = view.frame.height
    let frame = CGRect(x: xPos, y: yPos, width: view.frame.height, height: pickerViewHeight)
    let picker = TimePicker(presenterViewController: self, frame: frame)
    picker.delegate = self
    return picker
  }()
  
  private var modifiedItemIndexPath: IndexPath?
  private var items: [DigitalPictureFrameItem]?

  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
}


// MARK: - ViewSetupable protocol
extension SettingsViewController {
  
  override func setup() {
    super.setup()
    registerCells()
    createAndAssembleSettingsItem()
  }
  
  
  func createAndAssembleSettingsItem() {
    let settings = DatabaseManager.shared().settings
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


// MARK: - ListPickerViewDelegate protocol
extension SettingsViewController {
  
  func listPicker(_ listPicker: ListPickerView, didPressDone sender: UIDatePicker) {
    guard let modifiedItemIndexPath = modifiedItemIndexPath else { return }
    guard let modifiedTimeFrameItem = dataSourceDelegate?.item(at: modifiedItemIndexPath) as? SettingsTimeItem else { return }
    guard let selectedTime = Date.date(sender.date) else { return }
    
    let time = modifiedTimeFrameItem.cells[modifiedItemIndexPath.row]
    time.value = selectedTime
    reloadRows(at: modifiedItemIndexPath)
    timePicker.dismiss()
  }
  
  func listPicker(_ listPicker: ListPickerView, didPressCancel sender: UIDatePicker) {
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

// MARK: - WeatherZipcodeSettingsCellDelegate protocol
extension SettingsViewController {
  
  func weatherZipcodeSettingsCell(_ cell: WeatherZipcodeSettingsTableViewCell, didPressZipcodeButtonAt indexPath: IndexPath) {
    modifiedItemIndexPath = indexPath
    let title = "Weather Zip Code"
    let message = "Please type 5 digit zip code below"
    sharedAlert.delegate = self
    sharedAlert.presentSubmitAlert(in: self, title: title, message: message, textFieldConfiguration: { textField in
      textField.placeholder = "Zip Code"
      textField.keyboardAppearance = .dark
      textField.keyboardType = .numberPad
      textField.clearButtonMode = .whileEditing
      textField.delegate = self
    })
  }
}

// MARK: - UserInfoSettingsCellDelegate protocol
extension SettingsViewController {
  
  func userInfoSettingsCell(_ cell: UserInfoSettingsTableViewCell, didPressUserPickerButtonAt indexPath: IndexPath) {
    // TODO: Implement user picker view
  }
  
}

// MARK: - AlertViewPresenterDelegate protocol
extension SettingsViewController {
  
  func alertView(_ alertViewPresenter: AlertViewPresenter, didSubmit result: String) {
    guard let modifiedItemIndexPath = modifiedItemIndexPath else { return }
    guard let modifiedWeatherZipcodeItem = dataSourceDelegate?.item(at: modifiedItemIndexPath) as? SettingsWeatherZipCodeItem else { return }
    let newZipcode = result
    let weatherZipcode = modifiedWeatherZipcodeItem.cells[modifiedItemIndexPath.row]
    weatherZipcode.value = newZipcode
    reloadRows(at: modifiedItemIndexPath)
  }
  
}


// MARK: - UITextFieldDelegate protocol
extension SettingsViewController {
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let zipCodeCharactersLimit = 5
    
    let startingLength = textField.text?.count ?? 0
    let lengthToAdd = string.count
    let lengthToReplace =  range.length
    let newLength = startingLength + lengthToAdd - lengthToReplace
    
    return newLength <= zipCodeCharactersLimit
  }
  
}
