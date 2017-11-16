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
  private var activityData: ActivityData {
    return ActivityData(size: CGSize(width: 50, height: 50), type: .ballRotateChase, color: UIColor.appleBlue)
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
    delegate = self
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
        self.verifyUserCredentialsAndCreateDatabaseBased(on: data)
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
  
  func verifyUserCredentialsAndCreateDatabaseBased(on data: DigitalPictureFrameData) {
    guard let currentUserUDID = UIDevice.current.identifierForVendor?.uuidString, let providedUDID = data.UDID, currentUserUDID.contains(providedUDID) else {
      AlertViewPresenter.sharedInstance.presentPopupAlert(in: self, title: "Warning", message: DigitalPictureFrameDataError.invalidUserCredentials.description)
      DatabaseManager.shared().clearData()
      return
    }
    
    let _ = DatabaseManager.shared(data: data)
  }
  
}


// MARK: - UITabBarControllerDelegate protocol
extension DigitalPictureFrameViewController: UITabBarControllerDelegate {
  
  func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    guard let selectedTab = tabBarController.tabBar.selectedItem?.tag,
          let selectedType = TopTabBarItemType(rawValue: selectedTab) else { return }

    switch selectedType {
    case .users where viewController is UserViewController:
      print(selectedType.description)

    case .settings where viewController is SettingsViewController:
      print(selectedType.description) // add notification center to reload data in VC!!

    case .wifi where viewController is WiFiViewController:
      print(selectedType.description) // add notification center to reload data in VC!!
      
    default:
      break
    }
    
  }
}
