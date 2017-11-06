//
//  SettingsViewController.swift
//  Digital Picture Frame
//
//  Created by Pawel Milek on 11/2/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController {
  var settings: Settings? {
    didSet {
      createAndAssembleSettingsItem()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupStyle()
  }
}


// MARK: - ViewSetupable protocol
extension SettingsViewController {
  
  override func setup() {
    super.setup()
    registerCells()
  }
  
  func setupStyle() {
    tableView.separatorStyle = .none
  }

  func createAndAssembleSettingsItem() {
    guard let settings = settings else { return }
    let general = SettingsGeneralItem(rgbLight: settings.rgbLight, randomQuotes: settings.randomQuotes, sleep: settings.sleep, reset: settings.reset)
    let timeFrame = SettingsTimeItem(timeFrame: settings.timeFrame)
    let userInfo = SettingsUserInfoItem(sideInfo: settings.sideInfo)
    let weatherZipcode = SettingsWeatherZipCodeItem(weatherZip: settings.weatherZip)
    
    dataSourceDelegate = DigitalPictureFrameDataSource(items: [general, timeFrame, userInfo, weatherZipcode])
    
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
