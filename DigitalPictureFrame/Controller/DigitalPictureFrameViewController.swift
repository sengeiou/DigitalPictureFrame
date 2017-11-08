//
//  DigitalPictureFrameViewController.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/4/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class DigitalPictureFrameViewController: UITabBarController, ViewSetupable {
  @IBOutlet weak var topTabBar: UITabBar!
  private var shared: DatabaseManager?
  
  private var activityData: ActivityData {
    return ActivityData(size: CGSize(width: 50, height: 50), type: .ballSpinFadeLoader, color: UIColor.appleBlue)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    setupLayout()
  }

}

// MARK: - ViewSetupable protocol
extension DigitalPictureFrameViewController {
  
  func setup() {
    delegate = self
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


// MARK: - Load data
private extension DigitalPictureFrameViewController {
  
  func loadData() {
    NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    
    NetworkManager.shared.fetchData(completionHandler: {[unowned self] result in
      switch result {
      case .success(let decodeData):
        let _ = DatabaseManager.shared(data: decodeData)
        self.sendNotificationToReloadUserData()
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        
      case .failure(let error):
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        AlertViewPresenter.sharedInstance.presentErrorAlert(in: self, error: error)
        
      }
    })
  }
  
  func sendNotificationToReloadUserData() {
    NotificationCenter.default.post(name: NotificationName.reloadDataInUserViewController.name, object: nil)
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
