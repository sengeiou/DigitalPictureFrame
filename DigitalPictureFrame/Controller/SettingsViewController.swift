//
//  SettingsViewController.swift
//  Digital Picture Frame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit

class SettingsViewController: PageContentViewController, SwitchableCellDelegate {
  lazy private var timePicker: TimePickerView = {
    let pickerViewHeight = CGFloat(220.0)
    let xPos = CGFloat(0)
    let yPos = view.frame.height
    let frame = CGRect(x: xPos, y: yPos, width: view.frame.width, height: pickerViewHeight)
    let picker = TimePickerView(presenter: self, frame: frame)
    picker.delegate = self
    return picker
  }()
  
  lazy private var userPicker: UserPickerView = {
    let pickerViewHeight = CGFloat(220.0)
    let xPos = CGFloat(0)
    let yPos = view.frame.height
    let frame = CGRect(x: xPos, y: yPos, width: view.frame.width, height: pickerViewHeight)
    let picker = UserPickerView(presenter: self, frame: frame)
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
    reloadData()
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
  
  
  @objc override func reloadData() {
    createAndAssembleSettingsItem()
    updateTableView()
  }
  
  func createAndAssembleSettingsItem() {
    guard let settings = DatabaseManager.shared().settings else {
      clearDataSource()
      return
    }
    
    let general = SettingsGeneralItem(rgbLight: settings.rgbLight, randomQuotes: settings.randomQuotes, sleep: settings.sleep, reset: settings.reset)
    let timeFrame = SettingsTimeItem(timeFrame: settings.timeFrame)
    let userInfo = SettingsUserInfoItem(sideInfo: settings.sideInfo)
    let weatherZipcode = SettingsWeatherZipCodeItem(weatherZip: settings.weatherZip)
    items = [general, timeFrame, userInfo, weatherZipcode]
    createAndAssignDelegate(for: items!)
  }
}


// MARK: - TimePickerViewDelegate protocol
extension SettingsViewController: TimePickerViewDelegate {
  
  func timePicker(_ timePickerView: TimePickerView, didPressDone sender: UIDatePicker) {
    guard let modifiedItemIndexPath = modifiedItemIndexPath else { return }
    guard let modifiedTimeFrameItem = dataSourceDelegate?.item(at: modifiedItemIndexPath) else { return }
    guard let selectedTime = Date.date(sender.date) else { return }
    
    let time = modifiedTimeFrameItem.cells[modifiedItemIndexPath.row]
    time.value = selectedTime
    reloadRows(at: modifiedItemIndexPath)
    timePicker.dismiss()
  }
  
  func timePicker(_ timePickerView: TimePickerView, didPressCancel sender: UIDatePicker) {
    timePicker.dismiss()
  }
  
}

// MARK: - UserPickerViewDelegate protocol
extension SettingsViewController: UserPickerViewDelegate {
  
  func userPicker(_ userPickerView: UserPickerView, didPressDone picker: UIPickerView) {
    guard let modifiedItemIndexPath = modifiedItemIndexPath else { return }
    guard let modifiedUserInfoItem = dataSourceDelegate?.item(at: modifiedItemIndexPath) else { return }
    
    let selectedRow = picker.selectedRow(inComponent: 0)
    let user = userPickerView.item(at: selectedRow)!
    let userInfoName = modifiedUserInfoItem.cells[modifiedItemIndexPath.row]
    userInfoName.value = user.name
    reloadRows(at: modifiedItemIndexPath)
    userPicker.dismiss()
  }
  
  func userPicker(_ userPickerView: UserPickerView, didPressCancel picker: UIPickerView) {
    userPicker.dismiss()
  }

}


// MARK: - TimeFrameSettingsCellDelegate protocol
extension SettingsViewController: TimeFrameSettingsCellDelegate {
  
  func timeFrameSettingsCell(_ cell: TimeFrameSettingsTableViewCell, didPressTimePickerButtonAt indexPath: IndexPath) {
    modifiedItemIndexPath = indexPath
    timePicker.present()
  }
  
}


// MARK: - UserInfoSettingsCellDelegate protocol
extension SettingsViewController: UserInfoSettingsCellDelegate {
  
  func userInfoSettingsCell(_ cell: UserInfoSettingsTableViewCell, didPressUserPickerButtonAt indexPath: IndexPath) {
    modifiedItemIndexPath = indexPath
    userPicker.present()
  }
  
}

// MARK: - WeatherZipcodeSettingsCellDelegate protocol
extension SettingsViewController: WeatherZipcodeSettingsCellDelegate {
  
  func weatherZipcodeSettingsCell(_ cell: WeatherZipcodeSettingsTableViewCell, didPressZipcodeButtonAt indexPath: IndexPath) {
    modifiedItemIndexPath = indexPath
    let title = NSLocalizedString("SETTINGS_WEATHER_ZIPCODE_ALERT_TITLE", comment: "")
    let message = NSLocalizedString("SETTINGS_WEATHER_ZIPCODE_ALERT_MSG", comment: "")
    sharedAlert.delegate = self
    sharedAlert.presentSubmitAlert(in: self, title: title, message: message, textFieldConfiguration: { textField in
      textField.placeholder = NSLocalizedString("SETTINGS_WEATHER_ZIPCODE_ALERT_PLACEHOLDER", comment: "")
      textField.keyboardAppearance = .dark
      textField.keyboardType = .numberPad
      textField.clearButtonMode = .whileEditing
      textField.delegate = self
    })
  }
}



// MARK: - AlertViewPresenterDelegate protocol
extension SettingsViewController: AlertViewPresenterDelegate {
  
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
extension SettingsViewController: UITextFieldDelegate {
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let zipCodeCharactersLimit = 5
    
    let startingLength = textField.text?.count ?? 0
    let lengthToAdd = string.count
    let lengthToReplace =  range.length
    let newLength = startingLength + lengthToAdd - lengthToReplace
    
    return newLength <= zipCodeCharactersLimit
  }
  
}
