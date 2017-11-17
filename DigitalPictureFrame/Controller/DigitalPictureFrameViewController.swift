//
//  DigitalPictureFrameViewController.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class DigitalPictureFrameViewController: UITabBarController, ViewSetupable {
  @IBOutlet weak var topTabBar: UITabBar!
  private var data: DigitalPictureFrameData?
  private let defaults = UserDefaults.standard
  private let hasUserVerifiedPhoneNumberKey = "HasUserVerifiedPhoneNumber"
  private let usersEnteredPhoneNumber = "UsersEnteredPhoneNumber"
  private var activityData: ActivityData {
    return ActivityData(size: CGSize(width: 50, height: 50), type: .ballRotateChase, color: UIColor.appleBlue)
  }
  
  
  private var isUserPhoneNumberVerified: Bool {
    guard let data = data, let storedPhoneNumber = data.phoneNumber else { return false }
    guard let enteredPhoneNumber = defaults.string(forKey: usersEnteredPhoneNumber) else { return false }
    
    return enteredPhoneNumber.isEqual(to: storedPhoneNumber) && defaults.bool(forKey: hasUserVerifiedPhoneNumberKey)
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    setupLayout()
  }

  
  deinit {
    unregisterNotifications()
  }
}


// MARK: - ViewSetupable protocol
extension DigitalPictureFrameViewController {
  
  func setup() {
    registerNotifications()
    loadData()
  }
  
  
  func setupLayout() {
    func moveTabBarToTopOfScreen() {
      let statusBarHeight = UIApplication.shared.statusBarFrame.height
      let tabYPos = view.frame.origin.y + statusBarHeight
      var tabFrame = topTabBar.frame
      
      tabFrame.origin.y = tabYPos
      topTabBar.frame = tabFrame
    }
    
    moveTabBarToTopOfScreen()
  }
}


// MARK: - Add Notification Observer
extension DigitalPictureFrameViewController {
  
  func registerNotifications() {
    addRefreshDataNofificationObserver()
  }
  
  func unregisterNotifications() {
    removeRefreshDataNofificationObserver()
  }
  
  
  func addRefreshDataNofificationObserver() {
    NotificationCenter.default.addObserver(self, selector: #selector(DigitalPictureFrameViewController.refreshData(_:)),
                                           name: NotificationName.refreshData.name, object: nil)
  }
  
  func removeRefreshDataNofificationObserver() {
    NotificationCenter.default.removeObserver(self, name: NotificationName.refreshData.name, object: nil)
  }
  
  
  @objc func refreshData(_ sender: Any) {
    loadData()
  }
  
}


// MARK: - Load data
private extension DigitalPictureFrameViewController {
  
  func loadData() {
    NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    
    DatabaseManager.shared().retrieve(completionHandler: {[unowned self] result in
      switch result {
      case .success(let data):
        self.data = data
        self.verifyUserCredentials()
        self.sendNotificationToReloadUserData()
        self.sendNotificationToEndRefreshingIndicator()
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        
      case .failure(let error):
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        self.sendNotificationToReloadUserData()
        AlertViewPresenter.sharedInstance.presentErrorAlert(in: self, error: error)
      }
    })
  }
  
  
  func sendNotificationToReloadUserData() {
    NotificationCenter.default.post(name: NotificationName.reloadData.name, object: nil)
  }

  func sendNotificationToEndRefreshingIndicator() {
    NotificationCenter.default.post(name: NotificationName.endRefreshingIndicator.name, object: nil)
  }
}


// MARK: - Verify user credential
private extension DigitalPictureFrameViewController {
  
//  func verifyUserCredentialsAndCreateDatabaseBased(on data: DigitalPictureFrameData) { //46F45C7C-F002-4763-85B7-6136E0F4098A
//    guard let currentUserUDID = UIDevice.current.identifierForVendor?.uuidString, let providedUDID = data.UDID, currentUserUDID.isEqual(to: providedUDID) else {
//      AlertViewPresenter.sharedInstance.presentPopupAlert(in: self, title: "Warning", message: DigitalPictureFrameDataError.invalidUserCredentials.description)
//      DatabaseManager.shared().clearData()
//      return
//    }
//
//    let _ = DatabaseManager.shared(data: data)
//  }
  
  
  func verifyUserCredentials() {
    guard !isUserPhoneNumberVerified else {
      initDatabase()
      return
    }
    
    DatabaseManager.shared().clearData()
    sendNotificationToReloadUserData()
    
    let title = "User verification"
    let message = "Please type in current Phone Number"
    AlertViewPresenter.sharedInstance.delegate = self
    AlertViewPresenter.sharedInstance.presentSubmitAlert(in: self, title: title, message: message, textFieldConfiguration: { textField in
      textField.placeholder = "Phone Number"
      textField.keyboardAppearance = .dark
      textField.keyboardType = .phonePad
      textField.clearButtonMode = .whileEditing
    })
  }

  
  func initDatabase() {
    let _ = DatabaseManager.shared(data: data)
  }
}


// MARK: - AlertViewPresenterDelegate protocol
extension DigitalPictureFrameViewController: AlertViewPresenterDelegate {
  
  func alertView(_ alertViewPresenter: AlertViewPresenter, didSubmit result: String) {
    guard !result.isEmpty else { return }
    guard let retrivedData = data, let phoneNumber = retrivedData.phoneNumber else { return }
    
    let enteredPhoneNumber = result
    
    if phoneNumber.isEqual(to: enteredPhoneNumber) {
      NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
      defaults.set(true, forKey: hasUserVerifiedPhoneNumberKey)
      defaults.set(enteredPhoneNumber, forKey: usersEnteredPhoneNumber)
      initDatabase()
      sendNotificationToReloadUserData()
      NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
      
    } else {
      
      let title = "Error"
      let message = "Phone Number is different than what is currently associated with user."
      AlertViewPresenter.sharedInstance.presentPopupAlert(in: self, title: title, message: message)
      defaults.set(false, forKey: hasUserVerifiedPhoneNumberKey)
      defaults.set("", forKey: usersEnteredPhoneNumber)
    }
  }
  
}

